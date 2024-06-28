Event queues for queuing async tasks.

Multiple variations of the queue:
- Droppable
  - Discard events during processing current event.
- SingleElement
  - Queue holds max 1 element. So, if e.g three events are incoming during processing of current event, only the last one of the three is precessed after current event, the rest are discarded.
- Hybrid
  - Events are processed sequentially by default. But you may allow certain events to process concurrently by adding an `eventId` to each event and make use of the parameter `allowAsyncFor`.
- SyncAsync
  - A convenience wrapper around Hybrid when you want to add either in-sync or async elements (no need for adding ids manually).
- Custom queue, event priority, etc
  - You may pass a queueTransformer as a parameter to the queue to transform the queue however you like (not for Hybrid version though). The transformation is run after an event completes. You may use it e.g to change order of the queued events (prioritize some event id).