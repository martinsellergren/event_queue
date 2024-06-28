import 'dart:async';

import 'package:collection/collection.dart';

typedef EventQueueCallback<T> = Future<T?> Function();

typedef QueueTransformer<Id> = List<Event<Id>> Function(List<Event<Id>> queue);

typedef Event<Id> = ({
  EventQueueCallback event,
  Id? eventId,
  Completer completer
});

class EventQueue<Id> {
  List<Event<Id>> _queue = [];
  bool _isProcessing = false;
  bool mounted = true;

  final QueueTransformer<Id> queueTransformer;

  EventQueue({
    required this.queueTransformer,
  });

  EventQueue.singleElement()
      : queueTransformer = ((queue) => queue.isEmpty ? [] : [queue.last]);

  EventQueue.droppable() : queueTransformer = ((queue) => []);

  void dispose() {
    mounted = false;
  }

  bool get isEmpty => _queue.isEmpty;

  Future<T> call<T>(EventQueueCallback<T> event, {Id? eventId}) async {
    final completer = Completer();
    _queue.add((event: event, eventId: eventId, completer: completer));
    _step();
    return await completer.future;
  }

  void _step() async {
    if (_queue.isEmpty || _isProcessing || !mounted) return;
    final (:event, eventId: _, :completer) = _queue.removeAt(0);
    _isProcessing = true;
    completer.complete(await event());
    _isProcessing = false;
    transform(queueTransformer);
    _step();
  }

  void transform(QueueTransformer<Id> transformer) {
    _queue = transformer(_queue);
  }

  void clear() {
    _queue.clear();
  }
}

class SequentialEventQueue<Id> {
  List<Event<Id>> _queue = [];
  final List<Event<Id>> _active = [];
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
    _queue.add((event: event, eventId: eventId, completer: completer));
    _step();
    return await completer.future;
  }

  void _step() async {
    final next = _upNext();
    if (next == null || !mounted) return;
    _queue.remove(next);
    _active.add(next);
    _step();
    final (:event, eventId: _, :completer) = next;
    completer.complete(await event());
    _active.remove(next);
    _step();
  }

  Event<Id>? _upNext() {
    final next = _queue.firstOrNull;
    if (next == null) return null;
    final allowAsyncFor = this.allowAsyncFor;
    if (allowAsyncFor == null) return _active.isEmpty ? next : null;
    final allowNext = _active.every((e) =>
        e.eventId != null &&
        next.eventId != null &&
        allowAsyncFor(
          e.eventId as Id,
          next.eventId as Id,
        ));
    return allowNext ? next : null;
  }

  void transform(QueueTransformer<Id> transformer) {
    _queue = transformer(_queue);
  }

  void clear() {
    _queue.clear();
  }
}
