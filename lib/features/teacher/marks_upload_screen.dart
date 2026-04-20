import 'package:flutter/material.dart';

import '../../core/constants/app_constants.dart';
import '../../core/services/mock_data.dart';

class MarksUploadScreen extends StatefulWidget {
  const MarksUploadScreen({super.key});

  @override
  State<MarksUploadScreen> createState() => _MarksUploadScreenState();
}

class _MarksUploadScreenState extends State<MarksUploadScreen> {
  String _classId = 'c_10a';
  String _subjectId = 's_math';
  String _examName = 'Unit Test 2';
  double _maxMarks = 50;
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final c in _controllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final students = MockData.users
        .where((u) => u.classId == _classId && u.role.key == 'student')
        .toList();
    for (final s in students) {
      _controllers.putIfAbsent(s.id, () => TextEditingController());
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Upload Marks')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          DropdownButtonFormField<String>(
            value: _classId,
            items: MockData.classes
                .map((c) => DropdownMenuItem(
                      value: c.id,
                      child: Text('${c.name} ${c.section}'),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _classId = v!),
            decoration: const InputDecoration(labelText: 'Class'),
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            value: _subjectId,
            items: MockData.subjects
                .map((s) => DropdownMenuItem(
                      value: s.id,
                      child: Text(s.name),
                    ))
                .toList(),
            onChanged: (v) => setState(() => _subjectId = v!),
            decoration: const InputDecoration(labelText: 'Subject'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _examName,
            onChanged: (v) => _examName = v,
            decoration: const InputDecoration(labelText: 'Exam Name'),
          ),
          const SizedBox(height: 12),
          TextFormField(
            initialValue: _maxMarks.toStringAsFixed(0),
            keyboardType: TextInputType.number,
            onChanged: (v) => _maxMarks = double.tryParse(v) ?? 50,
            decoration: const InputDecoration(labelText: 'Max Marks'),
          ),
          const SizedBox(height: 20),
          Text('Enter marks',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  )),
          const SizedBox(height: 8),
          ...students.map((s) => Card(
                child: ListTile(
                  leading: CircleAvatar(child: Text(s.name[0])),
                  title: Text(s.name),
                  trailing: SizedBox(
                    width: 90,
                    child: TextField(
                      controller: _controllers[s.id],
                      keyboardType: TextInputType.number,
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '0 / ${_maxMarks.toStringAsFixed(0)}',
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 8),
                      ),
                    ),
                  ),
                ),
              )),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: students.isEmpty
                ? null
                : () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content:
                              Text('Marks uploaded successfully (demo mode)')),
                    );
                  },
            icon: const Icon(Icons.upload),
            label: const Text('Upload Marks'),
          ),
        ],
      ),
    );
  }
}
