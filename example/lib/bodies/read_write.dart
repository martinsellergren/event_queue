import 'package:event_queue/event_queue.dart';
import 'package:flutter/material.dart';

class ReadWriteBody extends StatefulWidget {
  const ReadWriteBody({super.key});

  @override
  State<ReadWriteBody> createState() => _ReadWriteBodyState();
}

class _ReadWriteBodyState extends State<ReadWriteBody> {
  final _queue = ReadWriteEventQueue();

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
            onPressed: _fireRead,
            child: const Text('Fire read'),
          ),
          TextButton(
            onPressed: _fireWrite,
            child: const Text('Fire write'),
          ),
          TextButton(
            onPressed: () => _queue.clearWrites(),
            child: const Text('Clear writes'),
          ),
          TextButton(
            onPressed: () => _queue.clear(),
            child: const Text('Clear all'),
          ),
        ],
      ),
    );
  }

  void _fireRead() => _queue.read(() async {
        print('fire read 0');
        await Future.delayed(const Duration(seconds: 1));
        print('fire read 1');
      });

  void _fireWrite() => _queue.write(() async {
        print('fire write 0');
        await Future.delayed(const Duration(seconds: 1));
        print('fire write 1');
      });
}
