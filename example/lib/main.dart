import 'package:event_queue_example/bodies/async.dart';
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
  sequential,
  droppable,
  singleElement,
  customPriority,
  async,
  syncAsync,
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
        body: TabBarView(
          children: CaseStudy.values
              .map((e) => switch (e) {
                    CaseStudy.sequential => const SequentialBody(),
                    CaseStudy.droppable => const DroppableBody(),
                    CaseStudy.singleElement => const SingleElementBody(),
                    CaseStudy.customPriority => const CustomPriorityBody(),
                    CaseStudy.async => const AsyncBody(),
                    CaseStudy.syncAsync => const SyncAsyncBody(),
                  })
              .toList(),
        ),
      ),
    );
  }
}
