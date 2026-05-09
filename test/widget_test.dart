import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:phero_app/main.dart';
import 'package:phero_app/core/di/service_locator.dart';

void main() {
  testWidgets('Counter increment smoke test', (WidgetTester tester) async {
    locator.setup();
    await tester.pumpWidget(const PheroApp());

    // Wait for initial load (simulated repository delay)
    await tester.pumpAndSettle();

    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}
