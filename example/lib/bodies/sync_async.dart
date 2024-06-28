import 'package:event_queue/sync_async_event_queue.dart';
import 'package:flutter/material.dart';

class SyncAsyncBody extends StatefulWidget {
  const SyncAsyncBody({super.key});

  @override
  State<SyncAsyncBody> createState() => _SyncAsyncBodyState();
}

class _SyncAsyncBodyState extends State<SyncAsyncBody> {
  final _queue = SyncAsyncEventQueue();

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
            onPressed: _fireSync,
            child: const Text('Fire sync'),
          ),
          TextButton(
            onPressed: _fireAsync,
            child: const Text('Fire async'),
          ),
          TextButton(
            onPressed: () => _queue.clear(),
            child: const Text('Clear'),
          ),
        ],
      ),
    );
  }

  void _fireSync() => _queue.sync(() async {
        print('fire sync 0');
        await Future.delayed(const Duration(seconds: 1));
        print('fire sync 1');
      });

  void _fireAsync() => _queue.async(() async {
        print('fire async 0');
        await Future.delayed(const Duration(seconds: 1));
        print('fire async 1');
      });
}
