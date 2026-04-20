import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('New assignment posted', 'Algebra Problem Set 4 is due in 3 days',
          Icons.assignment_outlined, Colors.deepPurple,
          DateTime.now().subtract(const Duration(minutes: 22))),
      ('Attendance marked', 'You were marked present today.',
          Icons.check_circle_outline, Colors.green,
          DateTime.now().subtract(const Duration(hours: 4))),
      ('Fees reminder', 'Term 2 fees due in 10 days', Icons.payments_outlined,
          Colors.orange, DateTime.now().subtract(const Duration(hours: 8))),
      ('New announcement', 'Annual Day Celebration', Icons.campaign_outlined,
          Colors.blue, DateTime.now().subtract(const Duration(hours: 20))),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Notifications')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final (title, body, icon, color, time) = items[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: color.withOpacity(0.12),
                child: Icon(icon, color: color),
              ),
              title: Text(title),
              subtitle: Text(body),
              trailing: Text(DateFormat('h:mm a').format(time),
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
            ),
          );
        },
      ),
    );
  }
}
