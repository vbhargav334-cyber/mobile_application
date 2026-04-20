import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';

class StudentFeesScreen extends ConsumerWidget {
  const StudentFeesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider);
    final fees = MockData.feesForStudent(user?.id ?? 'u_stu_1');
    final total = fees.fold<double>(0, (s, f) => s + f.amount);
    final paid = fees.fold<double>(0, (s, f) => s + f.paid);
    final pending = total - paid;

    return Scaffold(
      appBar: AppBar(title: const Text('Fees')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            color: Colors.orange.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  _feeStat('Total', total, Colors.blueGrey),
                  _feeStat('Paid', paid, Colors.green),
                  _feeStat('Pending', pending, Colors.orange.shade800),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          ...fees.map((f) => Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                        f.isPaid ? Colors.green.shade50 : Colors.orange.shade50,
                    child: Icon(
                      f.isPaid ? Icons.check : Icons.access_time,
                      color: f.isPaid ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(f.title),
                  subtitle: Text(
                      '₹${f.paid.toStringAsFixed(0)} / ₹${f.amount.toStringAsFixed(0)}\nDue: ${DateFormat('d MMM yyyy').format(f.dueDate)}'),
                  isThreeLine: true,
                  trailing: f.isPaid
                      ? const Chip(
                          label: Text('Paid'),
                          backgroundColor: Color(0xFFDCF8C6),
                          visualDensity: VisualDensity.compact,
                        )
                      : ElevatedButton(
                          onPressed: () => _showPayDialog(context, f.title, f.remaining),
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(80, 36),
                          ),
                          child: const Text('Pay'),
                        ),
                ),
              )),
        ],
      ),
    );
  }

  Widget _feeStat(String label, double value, Color color) => Expanded(
        child: Column(
          children: [
            Text('₹${value.toStringAsFixed(0)}',
                style: TextStyle(
                    color: color, fontSize: 18, fontWeight: FontWeight.w700)),
            const SizedBox(height: 2),
            Text(label, style: TextStyle(color: Colors.grey.shade700)),
          ],
        ),
      );

  void _showPayDialog(BuildContext context, String title, double amount) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Pay $title'),
        content: Text(
          'Amount: ₹${amount.toStringAsFixed(0)}\n\nRazorpay gateway will open here. (Integrate with real Razorpay API key to enable payments.)',
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                      content: Text('Payment simulated (demo mode)')),
                );
              },
              child: const Text('Proceed')),
        ],
      ),
    );
  }
}
