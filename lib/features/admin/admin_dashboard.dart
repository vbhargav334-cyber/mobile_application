import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/providers.dart';
import '../../shared/widgets/dashboard_card.dart';
import '../../shared/widgets/stat_tile.dart';

class AdminDashboard extends ConsumerWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final users = ref.watch(usersProvider);
    final students = users.where((u) => u.role.key == 'student').length;
    final teachers = users.where((u) => u.role.key == 'teacher').length;
    final parents = users.where((u) => u.role.key == 'parent').length;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Console'),
        actions: [
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
                    value: '$students',
                    color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                    icon: Icons.person_outline,
                    label: 'Teachers',
                    value: '$teachers',
                    color: Colors.green),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: StatTile(
                    icon: Icons.family_restroom,
                    label: 'Parents',
                    value: '$parents',
                    color: Colors.deepPurple),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: StatTile(
                    icon: Icons.class_,
                    label: 'Classes',
                    value: '2',
                    color: Colors.orange),
              ),
            ],
          ),
          const SizedBox(height: 20),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 3,
            childAspectRatio: 0.95,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              DashboardCard(
                icon: Icons.manage_accounts_outlined,
                title: 'Users',
                color: Colors.blue,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.class_,
                title: 'Classes',
                color: Colors.green,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.book_outlined,
                title: 'Subjects',
                color: Colors.deepPurple,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.event_outlined,
                title: 'Events',
                color: Colors.redAccent,
                onTap: () => context.push('/events'),
              ),
              DashboardCard(
                icon: Icons.settings_outlined,
                title: 'Settings',
                color: Colors.grey,
                onTap: () {},
              ),
              DashboardCard(
                icon: Icons.backup_outlined,
                title: 'Backup',
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
