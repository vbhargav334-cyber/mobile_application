import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/providers.dart';

class LeaveRequestsScreen extends ConsumerWidget {
  const LeaveRequestsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final requests = ref.watch(leaveRequestsProvider);
    return Scaffold(
      appBar: AppBar(title: const Text('Leave Requests')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: requests.length,
        itemBuilder: (context, i) {
          final r = requests[i];
          final days = r.to.difference(r.from).inDays + 1;
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      CircleAvatar(child: Text(r.studentName[0])),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(r.studentName,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w600)),
                            Text(
                                '${DateFormat('d MMM').format(r.from)} - ${DateFormat('d MMM').format(r.to)}  •  $days day${days == 1 ? '' : 's'}',
                                style: TextStyle(color: Colors.grey.shade600)),
                          ],
                        ),
                      ),
                      _statusChip(r.status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(r.reason),
                  if (r.status == 'pending') ...[
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Request rejected')),
                            );
                          },
                          child: const Text('Reject'),
                        ),
                        const SizedBox(width: 8),
                        FilledButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Request approved')),
                            );
                          },
                          child: const Text('Approve'),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    Color c;
    switch (status) {
      case 'approved':
        c = Colors.green;
        break;
      case 'rejected':
        c = Colors.red;
        break;
      default:
        c = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
          color: c.withOpacity(0.12),
          borderRadius: BorderRadius.circular(10)),
      child: Text(status,
          style:
              TextStyle(color: c, fontSize: 12, fontWeight: FontWeight.w600)),
    );
  }
}
