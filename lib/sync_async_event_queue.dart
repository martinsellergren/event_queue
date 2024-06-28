import 'event_queue.dart';

class SyncAsyncEventQueue extends SequentialEventQueue<EventType> {
  SyncAsyncEventQueue()
      : super(
          allowAsyncFor: (e1, e2) =>
              e1 == EventType.async && e2 == EventType.async,
        );

  @override
  // ignore: library_private_types_in_public_api
  Future<T> call<T>(EventQueueCallback<T> event, {EventType? eventId}) {
    return super.call(event, eventId: eventId);
  }

  Future<T> sync<T>(EventQueueCallback<T> event) {
    return call(event, eventId: EventType.sync);
  }

  Future<T> async<T>(EventQueueCallback<T> event) {
    return call(event, eventId: EventType.async);
  }
}

enum EventType {
  sync,
  async,
}
