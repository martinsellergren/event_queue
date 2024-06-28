import 'dart:async';

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

  EventQueue.sequential() : queueTransformer = ((queue) => queue);

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
    _queue = transformer(_queue);
  }

  void clear() {
    _queue.clear();
  }
}
