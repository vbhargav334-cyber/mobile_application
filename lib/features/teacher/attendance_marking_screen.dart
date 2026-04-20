import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/mock_data.dart';

class AttendanceMarkingScreen extends StatefulWidget {
  const AttendanceMarkingScreen({super.key});

  @override
  State<AttendanceMarkingScreen> createState() =>
      _AttendanceMarkingScreenState();
}

class _AttendanceMarkingScreenState extends State<AttendanceMarkingScreen> {
  String _classId = 'c_10a';
  final Map<String, bool> _present = {};

  @override
  Widget build(BuildContext context) {
    final students = MockData.users
        .where((u) => u.classId == _classId && u.role.key == 'student')
        .toList();

    for (final s in students) {
      _present.putIfAbsent(s.id, () => true);
    }

    final presentCount = _present.entries
        .where((e) => students.any((s) => s.id == e.key) && e.value)
        .length;

    return Scaffold(
      appBar: AppBar(title: const Text('Mark Attendance')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    value: _classId,
                    items: MockData.classes
                        .map((c) => DropdownMenuItem(
                              value: c.id,
                              child: Text('${c.name} ${c.section}'),
                            ))
                        .toList(),
                    onChanged: (v) => setState(() => _classId = v!),
                    decoration: const InputDecoration(labelText: 'Class'),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DateFormat('d MMM').format(DateTime.now()),
                  style: const TextStyle(
                      fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Text('Present: $presentCount / ${students.length}',
                    style: const TextStyle(fontWeight: FontWeight.w600)),
                const Spacer(),
                TextButton.icon(
                  onPressed: () => setState(() {
                    for (final s in students) {
                      _present[s.id] = true;
                    }
                  }),
                  icon: const Icon(Icons.check_circle_outline),
                  label: const Text('Mark all present'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: students.isEmpty
                ? const Center(child: Text('No students in this class'))
                : ListView.builder(
                    itemCount: students.length,
                    itemBuilder: (context, i) {
                      final s = students[i];
                      final present = _present[s.id] ?? true;
                      return SwitchListTile(
                        value: present,
                        onChanged: (v) => setState(() => _present[s.id] = v),
                        title: Text(s.name),
                        subtitle: Text(s.email),
                        secondary: CircleAvatar(
                          backgroundColor: present
                              ? Colors.green.shade50
                              : Colors.red.shade50,
                          child: Text(s.name[0]),
                        ),
                      );
                    },
                  ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: ElevatedButton.icon(
                onPressed: students.isEmpty
                    ? null
                    : () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text(
                                  'Attendance saved for today (demo mode)')),
                        );
                      },
                icon: const Icon(Icons.save),
                label: const Text('Save Attendance'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
