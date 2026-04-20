import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/providers/providers.dart';
import '../../core/services/mock_data.dart';

class StudentMarksScreen extends ConsumerWidget {
  const StudentMarksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(signedInUserProvider);
    final marks = MockData.marksForStudent(user?.id ?? 'u_stu_1');
    final subjects = MockData.subjects;
    final exams = marks.map((m) => m.examName).toSet().toList();

    return DefaultTabController(
      length: exams.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('My Marks'),
          bottom: TabBar(
            isScrollable: true,
            tabs: exams.map((e) => Tab(text: e)).toList(),
          ),
        ),
        body: TabBarView(
          children: exams.map((exam) {
            final list = marks.where((m) => m.examName == exam).toList();
            final total = list.fold<double>(0, (s, m) => s + m.marks);
            final max = list.fold<double>(0, (s, m) => s + m.maxMarks);
            final pct = max == 0 ? 0 : (total / max * 100);
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        _stat('Total', '${total.toStringAsFixed(0)}/${max.toStringAsFixed(0)}'),
                        _stat('Percent', '${pct.toStringAsFixed(1)}%'),
                        _stat('Grade', _grade(pct.toDouble())),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 240,
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: BarChart(
                        BarChartData(
                          alignment: BarChartAlignment.spaceAround,
                          maxY: list.isEmpty
                              ? 100
                              : list.map((m) => m.maxMarks).reduce((a, b) => a > b ? a : b),
                          titlesData: FlTitlesData(
                            topTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            rightTitles: const AxisTitles(
                                sideTitles: SideTitles(showTitles: false)),
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  final i = value.toInt();
                                  if (i < 0 || i >= list.length) {
                                    return const SizedBox.shrink();
                                  }
                                  final sub = subjects.firstWhere(
                                    (s) => s.id == list[i].subjectId,
                                    orElse: () => subjects.first,
                                  );
                                  return Padding(
                                    padding: const EdgeInsets.only(top: 6),
                                    child: Text(
                                      sub.name.substring(
                                          0, sub.name.length.clamp(0, 3)),
                                      style: const TextStyle(fontSize: 11),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          gridData: const FlGridData(show: true),
                          borderData: FlBorderData(show: false),
                          barGroups: [
                            for (int i = 0; i < list.length; i++)
                              BarChartGroupData(
                                x: i,
                                barRods: [
                                  BarChartRodData(
                                    toY: list[i].marks,
                                    color: Colors.blue,
                                    width: 18,
                                    borderRadius: BorderRadius.circular(6),
                                  ),
                                ],
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                ...list.map((m) {
                  final sub = subjects.firstWhere(
                    (s) => s.id == m.subjectId,
                    orElse: () => subjects.first,
                  );
                  return Card(
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Colors.blue.shade50,
                        child: Text(sub.name[0]),
                      ),
                      title: Text(sub.name),
                      subtitle: Text(
                          'Scored ${m.marks.toStringAsFixed(0)} / ${m.maxMarks.toStringAsFixed(0)}'),
                      trailing: Text('${m.percentage.toStringAsFixed(1)}%',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16)),
                    ),
                  );
                }),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _stat(String label, String value) => Column(
        children: [
          Text(value,
              style: const TextStyle(
                  fontSize: 20, fontWeight: FontWeight.w700)),
          const SizedBox(height: 2),
          Text(label, style: TextStyle(color: Colors.grey.shade600)),
        ],
      );

  String _grade(double pct) {
    if (pct >= 90) return 'A+';
    if (pct >= 80) return 'A';
    if (pct >= 70) return 'B+';
    if (pct >= 60) return 'B';
    if (pct >= 50) return 'C';
    if (pct >= 40) return 'D';
    return 'F';
  }
}
