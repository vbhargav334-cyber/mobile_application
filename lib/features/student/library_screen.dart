import 'package:flutter/material.dart';

class StudentLibraryScreen extends StatelessWidget {
  const StudentLibraryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final books = [
      ('The Wings of Fire', 'A. P. J. Abdul Kalam', true, '28 Apr 2026'),
      ('Wonder', 'R. J. Palacio', false, null),
      ('Panchatantra', 'Vishnu Sharma', true, '15 May 2026'),
      ('Discovery of India', 'Jawaharlal Nehru', false, null),
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Library')),
      body: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: books.length,
        itemBuilder: (context, i) {
          final (title, author, borrowed, due) = books[i];
          return Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: Colors.brown.shade50,
                child: const Icon(Icons.menu_book, color: Colors.brown),
              ),
              title: Text(title),
              subtitle: Text(author),
              trailing: borrowed
                  ? Chip(
                      label: Text('Due $due',
                          style: const TextStyle(fontSize: 11)),
                      backgroundColor: Colors.orange.shade50,
                      visualDensity: VisualDensity.compact,
                    )
                  : const Chip(
                      label: Text('Available',
                          style: TextStyle(fontSize: 11)),
                      backgroundColor: Color(0xFFDCF8C6),
                      visualDensity: VisualDensity.compact,
                    ),
            ),
          );
        },
      ),
    );
  }
}
