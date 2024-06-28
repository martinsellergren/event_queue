import 'package:event_queue/src/async_event_queue.dart';

import 'event_queue.dart';

enum SyncAsyncEventType {
  sync,
  async,
}

class SyncAsyncEventQueue extends AsyncEventQueue<SyncAsyncEventType> {
  SyncAsyncEventQueue()
      : super(
          allowAsyncFor: (e1, e2) =>
              e1 == SyncAsyncEventType.async && e2 == SyncAsyncEventType.async,
        );

  @override
  // ignore: library_private_types_in_public_api
  Future<T> call<T>(EventQueueCallback<T> event,
      {SyncAsyncEventType? eventId}) {
    return super.call(event, eventId: eventId);
  }

  Future<T> sync<T>(EventQueueCallback<T> event) {
    return call(event, eventId: SyncAsyncEventType.sync);
  }

  Future<T> async<T>(EventQueueCallback<T> event) {
    return call(event, eventId: SyncAsyncEventType.async);
  }
}
