import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';

class StudentAttendanceScreen extends ConsumerStatefulWidget {
  const StudentAttendanceScreen({super.key});

  @override
  ConsumerState<StudentAttendanceScreen> createState() =>
      _StudentAttendanceScreenState();
}

class _StudentAttendanceScreenState
    extends ConsumerState<StudentAttendanceScreen> {
  DateTime _focused = DateTime.now();
  DateTime? _selected;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(signedInUserProvider);
    final records = MockData.attendanceForStudent(user?.id ?? 'u_stu_1');
    final byDate = {
      for (final r in records) DateTime(r.date.year, r.date.month, r.date.day): r
    };
    final total = records.length;
    final present = records.where((r) => r.present).length;
    final pct = total == 0 ? 0 : (present / total * 100).round();

    return Scaffold(
      appBar: AppBar(title: const Text('My Attendance')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _statChip('Total', '$total', Colors.blue),
                  _statChip('Present', '$present', Colors.green),
                  _statChip('Absent', '${total - present}', Colors.red),
                  _statChip('%', '$pct%', Colors.deepPurple),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: TableCalendar(
                firstDay: DateTime.now().subtract(const Duration(days: 365)),
                lastDay: DateTime.now().add(const Duration(days: 30)),
                focusedDay: _focused,
                selectedDayPredicate: (d) => isSameDay(d, _selected),
                onDaySelected: (sel, foc) {
                  setState(() {
                    _selected = sel;
                    _focused = foc;
                  });
                },
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, _) {
                    final key = DateTime(date.year, date.month, date.day);
                    final rec = byDate[key];
                    if (rec == null) return const SizedBox.shrink();
                    return Positioned(
                      bottom: 4,
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: rec.present ? Colors.green : Colors.red,
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text('Recent',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 6),
          ...records.take(10).map((r) => Card(
                child: ListTile(
                  leading: Icon(
                    r.present ? Icons.check_circle : Icons.cancel,
                    color: r.present ? Colors.green : Colors.red,
                  ),
                  title: Text(DateFormat('EEEE, d MMM yyyy').format(r.date)),
                  subtitle: Text(r.present ? 'Present' : 'Absent'),
                ),
              )),
        ],
      ),
    );
  }

  Widget _statChip(String label, String value, Color color) => Expanded(
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: color)),
            const SizedBox(height: 2),
            Text(label,
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
          ],
        ),
      );
}
