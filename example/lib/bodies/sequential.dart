import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

enum _EventType {
  event1,
  event2,
  event3,
}

class SequentialBody extends StatefulWidget {
  const SequentialBody({super.key});

  @override
  State<SequentialBody> createState() => _SequentialBodyState();
}

class _SequentialBodyState extends State<SequentialBody> {
  final _queue = SequentialEventQueue<_EventType>(
    allowAsyncFor: (e1, e2) => [e1, e2].every(
      (e) => e == _EventType.event2 || e == _EventType.event3,
    ),
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
