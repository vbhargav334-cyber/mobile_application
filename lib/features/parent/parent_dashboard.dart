import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../shared/widgets/stat_tile.dart';

class ParentDashboard extends ConsumerStatefulWidget {
  const ParentDashboard({super.key});

  @override
  ConsumerState<ParentDashboard> createState() => _ParentDashboardState();
}

class _ParentDashboardState extends ConsumerState<ParentDashboard> {
  String? _childId;

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(signedInUserProvider);
    final children = MockData.users
        .where((u) =>
            user?.childIds.contains(u.id) ??
            u.role.key == 'student' && u.id == 'u_stu_1')
        .toList();
    _childId ??= children.isNotEmpty ? children.first.id : null;
    final child = children.firstWhere(
      (c) => c.id == _childId,
      orElse: () => children.isNotEmpty ? children.first : MockData.users.first,
    );
    final attendance = MockData.attendanceForStudent(child.id);
    final present = attendance.where((a) => a.present).length;
    final pct = attendance.isEmpty
        ? 0
        : (present / attendance.length * 100).round();
    final fees = MockData.feesForStudent(child.id);
    final pending = fees.where((f) => !f.isPaid).fold<double>(
        0, (s, f) => s + f.remaining);

    return Scaffold(
      appBar: AppBar(
        title: Text('Hi ${user?.name.split(' ').first ?? 'Parent'}'),
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
          if (children.length > 1)
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: DropdownButtonFormField<String>(
                value: _childId,
                items: children
                    .map((c) =>
                        DropdownMenuItem(value: c.id, child: Text(c.name)))
                    .toList(),
                onChanged: (v) => setState(() => _childId = v),
                decoration: const InputDecoration(labelText: 'Child'),
              ),
            ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 28,
                    child: Text(child.name[0],
                        style: const TextStyle(fontSize: 22)),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(child.name,
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w700)),
                        Text('Class 10 A'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
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
          const SizedBox(height: 24),
          Text('Quick access',
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
                icon: Icons.payments_outlined,
                title: 'Pay Fees',
                color: Colors.orange,
                onTap: () => context.push('/parent/fees'),
              ),
              DashboardCard(
                icon: Icons.chat_bubble_outline,
                title: 'Chat Teacher',
                color: Colors.pink,
                onTap: () => context.push('/chat'),
              ),
              DashboardCard(
                icon: Icons.campaign_outlined,
                title: 'Notices',
                color: Colors.blue,
                onTap: () => context.push('/announcements'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
