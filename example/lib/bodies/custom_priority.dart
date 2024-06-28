import 'package:collection/collection.dart';
import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

enum _EventType {
  event1,
  event2,
  event3,
}

class CustomPriorityBody extends StatefulWidget {
  const CustomPriorityBody({super.key});

  @override
  State<CustomPriorityBody> createState() => _CustomPriorityBodyState();
}

class _CustomPriorityBodyState extends State<CustomPriorityBody> {
  final _queue = EventQueue<_EventType>(
    // prioritize event1
    queueTransformer: (queue) => [
      ...queue.where((e) => e.eventId == _EventType.event1),
      ...queue.whereNot((e) => e.eventId == _EventType.event1),
    ],
  );

  @override
  void dispose() {
    _queue.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
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
            onPressed: () => _queue.clear(),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _fire1() => _queue(() async {
        print('fire10');
        await Future.delayed(const Duration(seconds: 1));
        print('fire11');
      }, eventId: _EventType.event1);

  void _fire2() => _queue(() async {
        print('fire20');
        await Future.delayed(const Duration(seconds: 1));
        print('fire21');
      }, eventId: _EventType.event2);

  void _fire3() => _queue(() async {
        print('fire30');
        await Future.delayed(const Duration(seconds: 1));
        print('fire31');
      }, eventId: _EventType.event3);
}
