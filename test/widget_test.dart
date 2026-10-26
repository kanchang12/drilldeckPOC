import 'package:drilldeck/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('home lists English and shows coming soon for other subjects', (tester) async {
    await tester.pumpWidget(const DrillDeckApp());

    expect(find.text('English'), findsOneWidget);
    expect(find.text('Reasoning'), findsOneWidget);

    await tester.tap(find.text('Reasoning'));
    await tester.pump();
    expect(find.text('Reasoning is coming soon.'), findsOneWidget);
  });

  testWidgets('English opens with New test and Completed', (tester) async {
    await tester.pumpWidget(const DrillDeckApp());
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    expect(find.text('New test'), findsOneWidget);
    expect(find.text('Completed'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });
}
