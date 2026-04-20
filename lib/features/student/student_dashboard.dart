import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../shared/widgets/stat_tile.dart';

class StudentDashboard extends ConsumerWidget {
  const StudentDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider);
    final attendance = MockData.attendanceForStudent(user?.id ?? 'u_stu_1');
    final present = attendance.where((a) => a.present).length;
    final pct = attendance.isEmpty
        ? 0
        : ((present / attendance.length) * 100).round();
    final fees = MockData.feesForStudent(user?.id ?? 'u_stu_1');
    final pending = fees.where((f) => !f.isPaid).fold<double>(
        0, (sum, f) => sum + f.remaining);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${user?.name.split(' ').first ?? 'Student'}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none),
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () => context.push('/profile'),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => await Future<void>.delayed(
            const Duration(milliseconds: 400)),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.check_circle_outline,
                    label: 'Attendance',
                    value: '$pct%',
                    color: Colors.green,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    icon: Icons.currency_rupee,
                    label: 'Fees Due',
                    value: '₹${pending.toStringAsFixed(0)}',
                    color: Colors.orange,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: StatTile(
                    icon: Icons.assignment_outlined,
                    label: 'Assignments',
                    value: '${MockData.assignments.length}',
                    color: Colors.deepPurple,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: StatTile(
                    icon: Icons.campaign_outlined,
                    label: 'Notices',
                    value: '${MockData.announcements.length}',
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Quick actions',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 12),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 3,
              childAspectRatio: 0.95,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: [
                DashboardCard(
                  icon: Icons.fact_check_outlined,
                  title: 'Attendance',
                  color: Colors.green,
                  onTap: () => context.push('/student/attendance'),
                ),
                DashboardCard(
                  icon: Icons.grading_outlined,
                  title: 'Marks',
                  color: Colors.indigo,
                  onTap: () => context.push('/student/marks'),
                ),
                DashboardCard(
                  icon: Icons.table_chart_outlined,
                  title: 'Timetable',
                  color: Colors.teal,
                  onTap: () => context.push('/student/timetable'),
                ),
                DashboardCard(
                  icon: Icons.assignment_outlined,
                  title: 'Assignments',
                  color: Colors.deepPurple,
                  onTap: () => context.push('/student/assignments'),
                ),
                DashboardCard(
                  icon: Icons.payments_outlined,
                  title: 'Fees',
                  color: Colors.orange,
                  onTap: () => context.push('/student/fees'),
                ),
                DashboardCard(
                  icon: Icons.menu_book_outlined,
                  title: 'Library',
                  color: Colors.brown,
                  onTap: () => context.push('/student/library'),
                ),
                DashboardCard(
                  icon: Icons.folder_copy_outlined,
                  title: 'Materials',
                  color: Colors.pink,
                  onTap: () => context.push('/student/study-materials'),
                ),
                DashboardCard(
                  icon: Icons.event_note_outlined,
                  title: 'Events',
                  color: Colors.redAccent,
                  onTap: () => context.push('/events'),
                ),
                DashboardCard(
                  icon: Icons.campaign_outlined,
                  title: 'Notices',
                  color: Colors.blue,
                  onTap: () => context.push('/announcements'),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text('Today\'s classes',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    )),
            const SizedBox(height: 8),
            ..._todaysClasses().map((slot) => Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor:
                          Theme.of(context).colorScheme.primaryContainer,
                      child: const Icon(Icons.schedule),
                    ),
                    title: Text(slot.subjectName),
                    subtitle: Text(
                        '${slot.startTime} - ${slot.endTime}   •   ${slot.room}'),
                    trailing: Text(slot.teacherName,
                        style: const TextStyle(fontSize: 12)),
                  ),
                )),
          ],
        ),
      ),
    );
  }

  List _todaysClasses() {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final today = days[DateTime.now().weekday - 1];
    return MockData.timetable.where((t) => t.day == today).toList();
  }
}
