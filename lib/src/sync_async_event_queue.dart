import 'package:event_queue/src/async_event_queue.dart';

import 'event_queue.dart';

enum _EventType {
  sync,
  async,
}

class SyncAsyncEventQueue extends AsyncEventQueue<_EventType> {
  SyncAsyncEventQueue()
      : super(
          allowAsyncFor: (e1, e2) =>
              e1 == _EventType.async && e2 == _EventType.async,
        );

  @override
  // ignore: library_private_types_in_public_api
  Future<T> call<T>(EventQueueCallback<T> event, {_EventType? eventId}) {
    return super.call(event, eventId: eventId);
  }

  Future<T> sync<T>(EventQueueCallback<T> event) {
    return call(event, eventId: _EventType.sync);
  }

  Future<T> async<T>(EventQueueCallback<T> event) {
    return call(event, eventId: _EventType.async);
  }
}
