Event queues for queuing async tasks.

##  Features

- `EventQueue.sequential()`
  - Next event starts when previous one completes.
- `EventQueue.droppable()`
  - Discard events during processing current event.
- `EventQueue.singleElement()`
  - Queue holds max 1 element (event). So, if e.g three events are incoming during processing of current event, only the last one of the three is processed after current event, the rest are discarded.
- Custom `EventQueue()`, for event priority, etc
  - Using the default constructor, events are processed sequentially but you pass a queueTransformer as constructor parameter to transform the queue however you like. The transformation is run after an event completes before determining next event. You may use it e.g to change order of the queued events (prioritize some event id) or filter out certain events.
- `AsyncEventQueue()` (concurrent processing)
  - Events are processed in-sync (sequentially) by default but you may allow certain events to process async (concurrently) by adding an id to each event and make use of the parameter `allowAsyncFor`.
- `ReadWriteEventQueue()`
  - A convenience wrapper around AsyncEventQueue for when you have read and writes operations, and want read operations to happen concurrently and write operations sequentially (i.e sequentially with both read and other write operations).

## Basic usage

```dart
final _queue = EventQueue.sequential();

TextButton(
  onPressed: () => _queue(() async {
    print('fire0');
    await Future.delayed(const Duration(seconds: 1));
    print('fire1');
  }),
  child: const Text('Fire'),
)
```