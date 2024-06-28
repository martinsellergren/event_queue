import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

class DroppableBody extends StatefulWidget {
  const DroppableBody({super.key});

  @override
  State<DroppableBody> createState() => _DroppableBodyState();
}

class _DroppableBodyState extends State<DroppableBody> {
  final _queue = EventQueue.droppable();

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
        print('fire1');
      });
}
