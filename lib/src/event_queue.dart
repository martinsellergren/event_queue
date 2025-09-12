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
  }

  bool get isEmpty => _queue.isEmpty;

  /// Set to true when calling clear().
  /// Set to false again when a new event is processed.
  /// Use it if you need to cancel any currently processing work, in addition to
  /// clearing the upcoming items.
  bool get isCleared => _isCleared;

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
    _isCleared = false;
    Function(Completer completer) completeCompleter;
    try {
      final res = await event();
      completeCompleter = (completer) => completer.complete(res);
    } catch (e, s) {
      completeCompleter = (completer) => completer.completeError(e, s);
    }
    completeCompleter(completer);
    _isProcessing = false;
    _transform(
      transformer: queueTransformer,
      completeDiscardedCompleter: completeCompleter,
    );
    _step();
  }

  void _transform(
      {required QueueTransformer<Id> transformer,
      required Function(Completer completer) completeDiscardedCompleter}) {
    final queue0 = _queue.toList();
    _queue = transformer(_queue);
    queue0
        .toSet()
        .difference(_queue.toSet())
        .forEach((e) => completeDiscardedCompleter(e.completer));
  }

  void clear() {
    _queue.clear();
    _isCleared = true;
  }
}
