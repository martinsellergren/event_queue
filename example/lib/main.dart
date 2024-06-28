import 'package:event_queue_example/bodies/custom_priority.dart';
import 'package:event_queue_example/bodies/droppable.dart';
import 'package:event_queue_example/bodies/sequential.dart';
import 'package:event_queue_example/bodies/single_element.dart';
import 'package:event_queue_example/bodies/sync_async.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MaterialApp(home: _Page()));
}

enum CaseStudy {
  droppable,
  singleElement,
  sequential,
  syncAsync,
  customPriority,
}

class _Page extends StatelessWidget {
  const _Page();

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: CaseStudy.values.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Event queue example'),
          bottom: TabBar(
            tabs: CaseStudy.values.map((e) => Tab(text: e.name)).toList(),
          ),
        ),
        body: const TabBarView(
          children: [
            DroppableBody(),
            SingleElementBody(),
            SequentialBody(),
            SyncAsyncBody(),
            CustomPriorityBody(),
          ],
        ),
      ),
    );
  }
}

// void _fire1() => _queue(() async {
//         print('fire10');
//         await Future.delayed(const Duration(seconds: 1));
//         // if (!_queue.isEmpty) return;
//         print('fire11');
//       }, eventId: EventType.event1);

//   void _fire2() => _queue(() async {
//         print('fire20');
//         await Future.delayed(const Duration(seconds: 1));
//         print('fire21');
//       }, eventId: EventType.event2);

//   void _fire3() => _queue(() async {
//         print('fire30');
//         await Future.delayed(const Duration(seconds: 1));
//         print('fire31');
//       }, eventId: EventType.event3);

// enum EventType {
//   event1,
//   event2,
//   event3,
// }

