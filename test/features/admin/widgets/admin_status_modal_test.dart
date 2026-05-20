import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/domain/models/report.dart';
import 'package:phero_app/features/admin/widgets/admin_status_modal.dart';
import 'package:phero_app/core/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

void main() {
  final testReport = Report(
    id: '1',
    title: 'Test Report',
    description: 'Test Description',
    userId: 'user1',
    timestamp: DateTime.now(),
    latitude: 0.0,
    longitude: 0.0,
    status: 'pending',
  );

  Widget buildTestableWidget(Widget child) {
    return MaterialApp(
      home: Scaffold(
        body: ChangeNotifierProvider<ThemeNotifier>(
          create: (_) => ThemeNotifier(),
          child: child,
        ),
      ),
    );
  }

  testWidgets('AdminStatusModal should display correct initial status', (WidgetTester tester) async {
    await tester.pumpWidget(
      buildTestableWidget(
        AdminStatusModal(
          report: testReport,
          onStatusUpdate: (_) async => true,
        ),
      ),
    );

    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('Update Status'), findsOneWidget);
  });

  testWidgets('AdminStatusModal should call onStatusUpdate when Confirm Update is pressed', (WidgetTester tester) async {
    String? updatedStatus;
    await tester.pumpWidget(
      buildTestableWidget(
        AdminStatusModal(
          report: testReport,
          onStatusUpdate: (status) async {
            updatedStatus = status;
            return true;
          },
        ),
      ),
    );

    // Open dropdown
    await tester.tap(find.text('Pending'));
    await tester.pumpAndSettle();

    // Select 'Resolved'
    await tester.tap(find.text('Resolved').last);
    await tester.pumpAndSettle();

    // Confirm Update
    await tester.tap(find.text('Confirm Update'));
    await tester.pumpAndSettle();

    expect(updatedStatus, 'resolved');
  });
}
