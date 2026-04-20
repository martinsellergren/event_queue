## 0.3.0

* Events return null if discarded/cleared/!mounted

## 0.2.0

* Make transform private, and always complete completers.

Before, a discarded event's completer would never finish. Now they finish with same result as the last completed event.

## 0.1.7

* Add isCleared flag.

## 0.1.6

* Fix nullability bug of EventQueueCallback.

## 0.1.5

* Make event errors catchable.

## 0.1.4

* Clean up ReadWriteEventQueue.

## 0.1.3

* Minor fix.

## 0.1.2

* Rename SyncAsyncEventQueue to ReadWriteEventQueue.

## 0.1.1

* Make SyncAsyncEventQueue's event type public.

## 0.1.0

* Add SyncAsyncEventQueue.
* More flexible queueTransformer.
* Renamings and restructurings.
* Improved readme.

## 0.0.1

* Initial.
