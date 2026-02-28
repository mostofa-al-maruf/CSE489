// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vangtichi/main.dart';

void main() {
  testWidgets('VangtiChai smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const VangtiChaiApp());

    // Verify that our app shows 'Taka: '
    expect(find.text('Taka: '), findsOneWidget);

    // Verify that tapping '1' adds it to the amount string
    await tester.tap(find.widgetWithText(ElevatedButton, '1'));
    await tester.pump();

    // Tap 'CLEAR' to clear
    await tester.tap(find.widgetWithText(ElevatedButton, 'CLEAR'));
    await tester.pump();
  });
}
