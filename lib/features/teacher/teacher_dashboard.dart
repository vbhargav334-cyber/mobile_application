import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../shared/widgets/stat_tile.dart';

class TeacherDashboard extends ConsumerWidget {
  const TeacherDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider);
    final pendingLeaves = MockData.leaveRequests
        .where((l) => l.status == 'pending')
        .length;
    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${user?.name.split(' ').first ?? 'Teacher'}'),
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
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(
                child: StatTile(
                    icon: Icons.groups,
                    label: 'My Classes',
                    value: '${MockData.classes.where((c) => c.classTeacherId == user?.id).length + 2}',
                    color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                    icon: Icons.assignment_ind_outlined,
                    label: 'Leave Reqs',
                    value: '$pendingLeaves',
                    color: Colors.orange),
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
                title: 'Mark Attendance',
                color: Colors.green,
                onTap: () => context.push('/teacher/attendance'),
              ),
              DashboardCard(
                icon: Icons.upload_file_outlined,
                title: 'Upload Marks',
                color: Colors.indigo,
                onTap: () => context.push('/teacher/marks-upload'),
              ),
              DashboardCard(
                icon: Icons.assignment_turned_in_outlined,
                title: 'Leave Reqs',
                color: Colors.orange,
                onTap: () => context.push('/teacher/leave-requests'),
              ),
              DashboardCard(
                icon: Icons.table_chart_outlined,
                title: 'Timetable',
                color: Colors.teal,
                onTap: () => context.push('/student/timetable'),
              ),
              DashboardCard(
                icon: Icons.campaign_outlined,
                title: 'Announcements',
                color: Colors.blue,
                onTap: () => context.push('/announcements'),
              ),
              DashboardCard(
                icon: Icons.chat_bubble_outline,
                title: 'Chat',
                color: Colors.pink,
                onTap: () => context.push('/chat'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Text('Today\'s schedule',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 8),
          ...MockData.timetable
              .where((t) => _today(t.day))
              .take(5)
              .map((s) => Card(
                    child: ListTile(
                      leading: const Icon(Icons.schedule),
                      title: Text(s.subjectName),
                      subtitle: Text('${s.startTime} - ${s.endTime} • ${s.room}'),
                    ),
                  )),
        ],
      ),
    );
  }

  bool _today(String day) {
    const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[DateTime.now().weekday - 1] == day;
  }
}
