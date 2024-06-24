import 'dart:async';

import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: _Page()));
}

class _Page extends StatefulWidget {
  const _Page();

  @override
  State<_Page> createState() => _PageState();
}

class _PageState extends State<_Page> {
  late final _queue = SequentialEventQueue<EventType>(
    allowAsyncFor: (e1, e2) =>
        [e1, e2].every((e) => e == EventType.event1 || e == EventType.event2),
  );

  @override
  void dispose() {
    _queue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Event queue'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: _fire1,
              child: const Text('Fire1'),
            ),
            TextButton(
              onPressed: _fire2,
              child: const Text('Fire2'),
            ),
            TextButton(
              onPressed: _fire3,
              child: const Text('Fire3'),
            ),
            TextButton(
              onPressed: () =>
                  _queue.transform((id, i, n) => id == EventType.event1),
              child: const Text('Clear queue'),
            ),
          ],
        ),
      ),
    );
  }

  void _fire1() => _queue(() async {
        print('fire10');
        await Future.delayed(const Duration(seconds: 1));
        // if (!_queue.isEmpty) return;
        print('fire11');
      }, eventId: EventType.event1);

  void _fire2() => _queue(() async {
        print('fire20');
        await Future.delayed(const Duration(seconds: 1));
        print('fire21');
      }, eventId: EventType.event2);

  void _fire3() => _queue(() async {
        print('fire30');
        await Future.delayed(const Duration(seconds: 1));
        print('fire31');
      }, eventId: EventType.event3);
}

enum EventType {
  event1,
  event2,
  event3,
}
