import 'dart:async';

import 'package:collection/collection.dart';

typedef EventQueueCallback<T> = Future<T?> Function();

typedef QueueTransformer<Id> = bool Function(Id? id, int i, int n);

typedef _Event<Id> = (
  EventQueueCallback callback,
  Id? eventId,
  Completer completer
);

class EventQueue<Id> {
  List<_Event<Id>> _queue = [];
  bool _isProcessing = false;
  bool mounted = true;

  final QueueTransformer<Id> queueTransformer;
  final bool Function(Id e1, Id e2)? allowAsyncFor;

  EventQueue({
    required this.queueTransformer,
    this.allowAsyncFor,
  });

  EventQueue.singleElement()
      : allowAsyncFor = null,
        queueTransformer = ((id, i, n) => i == n - 1);

  EventQueue.droppable()
      : allowAsyncFor = null,
        queueTransformer = ((id, i, n) => false);

  void dispose() {
    mounted = false;
  }

  bool get isEmpty => _queue.isEmpty;

  Future<T> call<T>(EventQueueCallback<T> event, {Id? eventId}) async {
    final completer = Completer();
    _queue.add((event, eventId, completer));
    _step();
    return await completer.future;
  }

  void _step() async {
    if (_queue.isEmpty || _isProcessing || !mounted) return;
    final (event, _, completer) = _queue.removeAt(0);
    _isProcessing = true;
    completer.complete(await event());
    _isProcessing = false;
    transform(queueTransformer);
    _step();
  }

  void transform(QueueTransformer<Id> transformer) {
    _queue = _queue
        .whereIndexed((i, e) => transformer(e.$2, i, _queue.length))
        .toList();
  }

  void clear() {
    _queue.clear();
  }
}

class SequentialEventQueue<Id> {
  List<_Event<Id>> _queue = [];
  final List<_Event<Id>> _active = [];
  bool mounted = true;

  final bool Function(Id e1, Id e2)? allowAsyncFor;

  SequentialEventQueue({
    this.allowAsyncFor,
  });

  void dispose() {
    mounted = false;
  }

  bool get isEmpty => _queue.isEmpty;

  Future<T> call<T>(EventQueueCallback<T> event, {Id? eventId}) async {
    final completer = Completer();
    _queue.add((event, eventId, completer));
    _step();
    return await completer.future;
  }

  void _step() async {
    final next = _upNext();
    if (next == null || !mounted) return;
    _queue.remove(next);
    _active.add(next);
    _step();
    final (event, _, completer) = next;
    completer.complete(await event());
    _active.remove(next);
    _step();
  }

  _Event<Id>? _upNext() {
    final next = _queue.firstOrNull;
    if (next == null) return null;
    final allowAsyncFor = this.allowAsyncFor;
    if (allowAsyncFor == null) return _active.isEmpty ? next : null;
    final allowNext = _active.every((e) =>
        e.$2 != null &&
        next.$2 != null &&
        allowAsyncFor(
          e.$2 as Id,
          next.$2 as Id,
        ));
    return allowNext ? next : null;
  }

  void transform(QueueTransformer<Id> transformer) {
    _queue = _queue
        .whereIndexed((i, e) => transformer(e.$2, i, _queue.length))
        .toList();
  }

  void clear() {
    _queue.clear();
  }
}
