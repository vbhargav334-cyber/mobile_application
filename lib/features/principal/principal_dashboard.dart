import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../shared/widgets/stat_tile.dart';

class PrincipalDashboard extends ConsumerWidget {
  const PrincipalDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider);
    final users = MockData.users;
    final totalStudents = users.where((u) => u.role.key == 'student').length;
    final totalTeachers = users.where((u) => u.role.key == 'teacher').length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome ${user?.name.split(' ').first ?? 'Principal'}'),
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
                    icon: Icons.school,
                    label: 'Students',
                    value: '$totalStudents',
                    color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                    icon: Icons.person_outline,
                    label: 'Teachers',
                    value: '$totalTeachers',
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatTile(
                    icon: Icons.class_,
                    label: 'Classes',
                    value: '${MockData.classes.length}',
                    color: Colors.deepPurple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                    icon: Icons.payments,
                    label: 'Collection',
                    value: '₹2.4L',
                    color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Attendance this week',
                      style: TextStyle(
                          fontWeight: FontWeight.w600, fontSize: 15)),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 180,
                    child: LineChart(
                      LineChartData(
                        titlesData: FlTitlesData(
                          topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false)),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, _) {
                                const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
                                final i = value.toInt();
                                if (i < 0 || i >= days.length) {
                                  return const SizedBox.shrink();
                                }
                                return Padding(
                                  padding: const EdgeInsets.only(top: 6),
                                  child: Text(days[i],
                                      style: const TextStyle(fontSize: 11)),
                                );
                              },
                            ),
                          ),
                        ),
                        minY: 60,
                        maxY: 100,
                        lineBarsData: [
                          LineChartBarData(
                            spots: const [
                              FlSpot(0, 92),
                              FlSpot(1, 88),
                              FlSpot(2, 94),
                              FlSpot(3, 90),
                              FlSpot(4, 91),
                              FlSpot(5, 86),
                            ],
                            isCurved: true,
                            color: Colors.blue,
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: Colors.blue.withOpacity(0.12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('Manage',
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
                icon: Icons.group_outlined,
                title: 'Staff',
                color: Colors.green,
                onTap: () => context.push('/principal/staff'),
              ),
              DashboardCard(
                icon: Icons.people_outline,
                title: 'Students',
                color: Colors.blue,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.payments_outlined,
                title: 'Fees',
                color: Colors.orange,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.campaign_outlined,
                title: 'Announce',
                color: Colors.pink,
                onTap: () => context.push('/announcements'),
              ),
              DashboardCard(
                icon: Icons.event_outlined,
                title: 'Events',
                color: Colors.redAccent,
                onTap: () => context.push('/events'),
              ),
              DashboardCard(
                icon: Icons.description_outlined,
                title: 'Reports',
                color: Colors.teal,
                onTap: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }
}
