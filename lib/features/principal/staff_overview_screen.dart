import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/constants/app_constants.dart';
import '../../core/providers/providers.dart';

class StaffOverviewScreen extends ConsumerWidget {
  const StaffOverviewScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final teachers =
        ref.watch(usersProvider).where((u) => u.role.key == 'teacher').toList();
    return Scaffold(
      appBar: AppBar(title: const Text('Staff')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: teachers.length,
        itemBuilder: (context, i) {
          final t = teachers[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(child: Text(t.name[0])),
              title: Text(t.name),
              subtitle: Text(t.email),
              trailing: IconButton(
                icon: const Icon(Icons.chat_bubble_outline),
                onPressed: () {},
              ),
            ),
          );
        },
      ),
    );
  }
}
