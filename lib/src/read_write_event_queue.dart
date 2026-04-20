import 'package:event_queue/src/async_event_queue.dart';

import 'event_queue.dart';

enum _ReadWriteEvent {
  read,
  write,
}

/// Sequential reads are allowed to be async.
class ReadWriteEventQueue {
  final _queue = AsyncEventQueue<_ReadWriteEvent>(
    allowAsyncFor: (e1, e2) =>
        e1 == _ReadWriteEvent.read && e2 == _ReadWriteEvent.read,
  );

  Future<T?> read<T>(EventQueueCallback<T> event) {
    return _queue(event, eventId: _ReadWriteEvent.read);
  }

  Future<T?> write<T>(EventQueueCallback<T> event) {
    return _queue(event, eventId: _ReadWriteEvent.write);
  }

  void clearWrites() {
    _queue.transform((queue) =>
        queue.where((e) => e.eventId != _ReadWriteEvent.write).toList());
  }

  void clear() {
    _queue.clear();
  }
}
