import 'dart:async';

typedef EventQueueCallback<T> = Future<T> Function();

typedef QueueTransformer<Id> = List<Event<Id>> Function(List<Event<Id>> queue);

typedef Event<Id> = ({
  EventQueueCallback event,
  Id? eventId,
  Completer completer
});

class EventQueue<Id> {
  List<Event<Id>> _queue = [];
  bool _isProcessing = false;
  bool _isCleared = false;
  bool mounted = true;

  final QueueTransformer<Id> queueTransformer;

  EventQueue({
    required this.queueTransformer,
  });

  EventQueue.singleElement()
      : queueTransformer = ((queue) => queue.isEmpty ? [] : [queue.last]);

  EventQueue.droppable() : queueTransformer = ((queue) => []);

  EventQueue.sequential() : queueTransformer = ((queue) => queue);

  void dispose() {
    mounted = false;
    clear();
  }

  bool get isEmpty => _queue.isEmpty;

  /// Set to true when calling clear().
  /// Set to false again when a new event is processed.
  /// Use it if you need to cancel any currently processing work, in addition to
  /// clearing the upcoming items.
  bool get isCleared => _isCleared;

  Future<T?> call<T>(EventQueueCallback<T> event, {Id? eventId}) async {
    if (!mounted) return null;
    final completer = Completer<T?>();
    _queue.add((event: event, eventId: eventId, completer: completer));
    _step();
    return await completer.future;
  }

  void _step() async {
    if (_queue.isEmpty || _isProcessing) return;
    final (:event, eventId: _, :completer) = _queue.removeAt(0);
    _isProcessing = true;
    _isCleared = false;
    try {
      final res = await event();
      completer.complete(res);
    } catch (e, s) {
      completer.completeError(e, s);
    }
    _isProcessing = false;
    transform(queueTransformer);
    _step();
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
    _isCleared = true;
  }
}
