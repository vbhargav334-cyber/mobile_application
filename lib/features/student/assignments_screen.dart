import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/services/mock_data.dart';

class StudentAssignmentsScreen extends StatelessWidget {
  const StudentAssignmentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = MockData.assignments;
    final subjects = MockData.subjects;
    return Scaffold(
      appBar: AppBar(title: const Text('Assignments')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final a = items[i];
          final sub = subjects.firstWhere(
            (s) => s.id == a.subjectId,
            orElse: () => subjects.first,
          );
          final daysLeft = a.dueDate.difference(DateTime.now()).inDays;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(sub.name,
                            style: TextStyle(
                                color: Colors.blue.shade800, fontSize: 12)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: daysLeft <= 1
                              ? Colors.red.shade50
                              : Colors.green.shade50,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          daysLeft <= 0
                              ? 'Due today'
                              : 'Due in $daysLeft day${daysLeft == 1 ? '' : 's'}',
                          style: TextStyle(
                              color: daysLeft <= 1
                                  ? Colors.red.shade700
                                  : Colors.green.shade800,
                              fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(a.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700, fontSize: 16)),
                  const SizedBox(height: 4),
                  Text(a.description,
                      style: TextStyle(color: Colors.grey.shade700)),
                  const SizedBox(height: 8),
                  Text('Due: ${DateFormat('d MMM yyyy').format(a.dueDate)}',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {},
                        icon: const Icon(Icons.attach_file, size: 18),
                        label: const Text('Submit'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
