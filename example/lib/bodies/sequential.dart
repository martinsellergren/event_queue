import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

class SequentialBody extends StatefulWidget {
  const SequentialBody({super.key});

  @override
  State<SequentialBody> createState() => _SequentialBodyState();
}

class _SequentialBodyState extends State<SequentialBody> {
  final _queue = EventQueue.sequential();

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
            onPressed: _fire,
            child: const Text('Fire'),
          ),
          TextButton(
            onPressed: () => _queue.clear(),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _fire() => _queue(() async {
        print('fire0');
        await Future.delayed(const Duration(seconds: 1));
        print('fire1');
      });
}
