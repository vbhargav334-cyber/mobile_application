import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/providers.dart';

class EventsScreen extends ConsumerWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final items = ref.watch(eventsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Events & Calendar')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final e = items[i];
          return Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(DateFormat('d').format(e.date),
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700)),
                    Text(DateFormat('MMM').format(e.date),
                        style: const TextStyle(fontSize: 11)),
                  ],
                ),
              ),
              title: Text(e.title),
              subtitle: Text(e.description),
            ),
          );
        },
      ),
    );
  }
}
