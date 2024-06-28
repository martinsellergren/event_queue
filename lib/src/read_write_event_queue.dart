import 'package:event_queue/src/async_event_queue.dart';

import 'event_queue.dart';

enum ReadWriteEvent {
  read,
  write,
}

/// Sequential reads are allowed to be async.
class ReadWriteEventQueue {
  final _queue = AsyncEventQueue<ReadWriteEvent>(
    allowAsyncFor: (e1, e2) =>
        e1 == ReadWriteEvent.read && e2 == ReadWriteEvent.read,
  );

  void dispose() {
    _queue.dispose();
  }

  Future<T> read<T>(EventQueueCallback<T> event) {
    return _queue(event, eventId: ReadWriteEvent.read);
  }

  Future<T> write<T>(EventQueueCallback<T> event) {
    return _queue(event, eventId: ReadWriteEvent.write);
  }

  void clearWrites() {
    _queue.transform((queue) =>
        queue.where((e) => e.eventId != ReadWriteEvent.write).toList());
  }

  void clear() {
    _queue.clear();
  }
}
