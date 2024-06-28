import 'package:event_queue/src/async_event_queue.dart';

import 'event_queue.dart';

enum ReadWriteEvent {
  read,
  write,
}

/// Sequential reads are allowed to be async.
class ReadWriteEventQueue extends AsyncEventQueue<ReadWriteEvent> {
  ReadWriteEventQueue()
      : super(
          allowAsyncFor: (e1, e2) =>
              e1 == ReadWriteEvent.read && e2 == ReadWriteEvent.read,
        );

  @override
  // ignore: library_private_types_in_public_api
  Future<T> call<T>(EventQueueCallback<T> event, {ReadWriteEvent? eventId}) {
    return super.call(event, eventId: eventId);
  }

  Future<T> read<T>(EventQueueCallback<T> event) {
    return call(event, eventId: ReadWriteEvent.read);
  }

  Future<T> write<T>(EventQueueCallback<T> event) {
    return call(event, eventId: ReadWriteEvent.write);
  }

  void clearWrites() {
    transform((queue) =>
        queue.where((e) => e.eventId != ReadWriteEvent.write).toList());
  }
}
