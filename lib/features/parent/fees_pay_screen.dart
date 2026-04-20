import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';

class ParentFeesPayScreen extends ConsumerWidget {
  const ParentFeesPayScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider);
    final childId =
        user?.childIds.isNotEmpty ?? false ? user!.childIds.first : 'u_stu_1';
    final fees = MockData.feesForStudent(childId);
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Fees')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...fees.map((f) => Card(
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(f.title,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16)),
                          ),
                          Chip(
                            label: Text(f.isPaid ? 'Paid' : 'Pending'),
                            backgroundColor: f.isPaid
                                ? const Color(0xFFDCF8C6)
                                : Colors.orange.shade50,
                            visualDensity: VisualDensity.compact,
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                          'Due ${DateFormat('d MMM yyyy').format(f.dueDate)}',
                          style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 10),
                      LinearProgressIndicator(
                        value: f.amount == 0 ? 0 : f.paid / f.amount,
                        backgroundColor: Colors.grey.shade200,
                        color: f.isPaid ? Colors.green : Colors.orange,
                      ),
                      const SizedBox(height: 8),
                      Text(
                          'Paid ₹${f.paid.toStringAsFixed(0)} of ₹${f.amount.toStringAsFixed(0)}'),
                      const SizedBox(height: 10),
                      if (!f.isPaid)
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _pay(context, f.title, f.remaining),
                            icon: const Icon(Icons.payments_outlined),
                            label: Text('Pay ₹${f.remaining.toStringAsFixed(0)}'),
                            style: ElevatedButton.styleFrom(
                                minimumSize: const Size(160, 40)),
                          ),
                        ),
                    ],
                  ),
                ),
              )),
        ],
      ),
    );
  }

  void _pay(BuildContext context, String title, double amount) {
    showDialog<void>(
      context: context,
      builder: (_) => AlertDialog(
        title: Text('Razorpay'),
        content: Text(
            'Paying ₹${amount.toStringAsFixed(0)} for "$title"\n\nIn production this opens the Razorpay checkout. Add your key in `PaymentService` and wire up `razorpay_flutter`.'),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel')),
          FilledButton(
              onPressed: () {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text('Paid ₹${amount.toStringAsFixed(0)} (demo)')),
                );
              },
              child: const Text('Proceed')),
        ],
      ),
    );
  }
}
