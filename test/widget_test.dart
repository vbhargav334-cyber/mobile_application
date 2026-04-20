import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:school_app/app.dart';

void main() {
  testWidgets('App boots and shows splash screen', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: SchoolApp()));
    await tester.pump();

    // Splash shows the app title.
    expect(find.text('School App'), findsWidgets);
    expect(find.byIcon(Icons.school_rounded), findsWidgets);
  });
}
