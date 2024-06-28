import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

class SingleElementBody extends StatefulWidget {
  const SingleElementBody({super.key});

  @override
  State<SingleElementBody> createState() => _SingleElementBodyState();
}

class _SingleElementBodyState extends State<SingleElementBody> {
  final _queue = EventQueue.singleElement();

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
        ],
      ),
    );
  }

  void _fire() => _queue(() async {
        print('fire0');
        await Future.delayed(const Duration(seconds: 1));
        if (!_queue.isEmpty) return;
        print('fire1');
      });
}
