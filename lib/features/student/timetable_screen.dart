import 'package:flutter/material.dart';

import '../../core/services/mock_data.dart';

class StudentTimetableScreen extends StatelessWidget {
  const StudentTimetableScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return DefaultTabController(
      length: days.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Timetable'),
          bottom: TabBar(
            isScrollable: true,
            tabs: days.map((d) => Tab(text: d)).toList(),
          ),
        ),
        body: TabBarView(
          children: days.map((day) {
            final slots = MockData.timetable.where((t) => t.day == day).toList();
            if (slots.isEmpty) {
              return const Center(child: Text('No classes'));
            }
            return ListView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: slots.length,
              itemBuilder: (context, i) {
                final s = slots[i];
                return Card(
                  child: ListTile(
                    leading: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(s.startTime,
                              style: const TextStyle(
                                  fontWeight: FontWeight.w700)),
                          Text(s.endTime,
                              style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontSize: 11)),
                        ],
                      ),
                    ),
                    title: Text(s.subjectName),
                    subtitle: Text('${s.teacherName}  •  ${s.room}'),
                  ),
                );
              },
            );
          }).toList(),
        ),
      ),
    );
  }
}
