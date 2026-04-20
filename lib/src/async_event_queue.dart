import 'dart:async';

import 'package:event_queue/src/event_queue.dart';

class AsyncEventQueue<Id> {
  List<Event<Id>> _queue = [];
  final List<Event<Id>> _active = [];
  bool mounted = true;

  final bool Function(Id e1, Id e2)? allowAsyncFor;

  AsyncEventQueue({
    this.allowAsyncFor,
  });

  void dispose() {
    mounted = false;
    clear();
  }

  bool get isEmpty => _queue.isEmpty;

  Future<T?> call<T>(EventQueueCallback<T> event, {Id? eventId}) async {
    if (!mounted) return null;
    final completer = Completer<T>();
    _queue.add((event: event, eventId: eventId, completer: completer));
    _step();
    return await completer.future;
  }

  void _step() async {
    final next = _upNext();
    if (next == null) return;
    _queue.remove(next);
    _active.add(next);
    _step();
    final (:event, eventId: _, :completer) = next;
    try {
      final res = await event();
      completer.complete(res);
    } catch (e, s) {
      completer.completeError(e, s);
    }
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
    final queue0 = _queue.toList();
    _queue = transformer(_queue);
    queue0
        .toSet()
        .difference(_queue.toSet())
        .forEach((e) => e.completer.complete(null));
  }

  void clear() {
    transform((queue) => []);
  }
}
