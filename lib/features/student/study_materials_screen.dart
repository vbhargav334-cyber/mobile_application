import 'package:flutter/material.dart';

class StudyMaterialsScreen extends StatelessWidget {
  const StudyMaterialsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final items = [
      ('Mathematics - Chapter 4 Notes', 'PDF', '1.2 MB'),
      ('Science - Acids and Bases', 'PDF', '820 KB'),
      ('English - Grammar Workbook', 'PDF', '2.4 MB'),
      ('Telugu - Poem Collection', 'PDF', '640 KB'),
      ('Social Studies - Maps', 'ZIP', '3.1 MB'),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Study Materials')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (context, i) {
          final (title, type, size) = items[i];
          return Card(
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.pink.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.insert_drive_file_outlined,
                    color: Colors.pink),
              ),
              title: Text(title),
              subtitle: Text('$type  •  $size'),
              trailing: IconButton(
                icon: const Icon(Icons.download_outlined),
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Downloading $title...')),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }
}
