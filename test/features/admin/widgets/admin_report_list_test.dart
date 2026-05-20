import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/domain/models/report.dart';
import 'package:phero_app/features/admin/widgets/admin_report_list.dart';
import 'package:phero_app/presentation/viewmodels/report_viewmodel.dart';
import 'package:phero_app/core/theme/theme_notifier.dart';
import 'package:provider/provider.dart';

class MockReportViewModel extends ChangeNotifier implements ReportViewModel {
  @override
  List<Report> reports = [];

  @override
  List<Report> userReports = [];

  @override
  List<Report> nearbyReports = [];

  @override
  bool isLoading = false;

  @override
  String? errorMessage;

  @override
  Future<void> loadReports() async {}

  @override
  Future<void> loadUserReports(String userId) async {}

  @override
  Future<void> loadNearbyReports(double latitude, double longitude, double radiusInKm) async {}

  @override
  Future<bool> submitReport({
    required String title,
    required String description,
    bool capturePhoto = false,
    String? localImagePath,
    double? latitude,
    double? longitude,
  }) async => true;

  @override
  Future<bool> updateReportStatus(String reportId, String newStatus) async => true;

  @override
  Future<bool> deleteReport(String reportId) async => true;
  
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  late MockReportViewModel mockReportViewModel;

  setUp(() {
    mockReportViewModel = MockReportViewModel();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<ThemeNotifier>(create: (_) => ThemeNotifier()),
        ChangeNotifierProvider<ReportViewModel>.value(value: mockReportViewModel),
      ],
      child: const MaterialApp(
        home: Scaffold(
          body: AdminReportList(
            targetStatuses: ['pending', 'in_progress'],
            isDark: false,
            primary: Color(0xFF3B4A2F),
            cardBg: Color(0xFFF5F7F2),
            textColor: Color(0xFF2C3A1E),
            subText: Color(0xFF8A9A7A),
          ),
        ),
      ),
    );
  }

  testWidgets('displays message when no reports found', (WidgetTester tester) async {
    mockReportViewModel.reports = [];
    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('No reports in this category.'), findsOneWidget);
  });

  testWidgets('displays list of reports matching target statuses', (WidgetTester tester) async {
    mockReportViewModel.reports = [
      Report(
        id: '1',
        title: 'Report 1',
        description: 'Description 1',
        userId: 'u1',
        timestamp: DateTime.now(),
        latitude: 0,
        longitude: 0,
        status: 'pending',
      ),
      Report(
        id: '2',
        title: 'Report 2',
        description: 'Description 2',
        userId: 'u2',
        timestamp: DateTime.now(),
        latitude: 0,
        longitude: 0,
        status: 'in_progress',
      ),
      Report(
        id: '3',
        title: 'Report 3',
        description: 'Description 3',
        userId: 'u3',
        timestamp: DateTime.now(),
        latitude: 0,
        longitude: 0,
        status: 'resolved',
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest());

    expect(find.text('Report 1'), findsOneWidget);
    expect(find.text('Report 2'), findsOneWidget);
    expect(find.text('Report 3'), findsNothing);
  });

  testWidgets('opens status modal when edit button is pressed', (WidgetTester tester) async {
    mockReportViewModel.reports = [
      Report(
        id: '1',
        title: 'Report 1',
        description: 'Description 1',
        userId: 'u1',
        timestamp: DateTime.now(),
        latitude: 0,
        longitude: 0,
        status: 'pending',
      ),
    ];

    await tester.pumpWidget(createWidgetUnderTest());

    await tester.tap(find.byIcon(Icons.edit_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Update Status'), findsOneWidget);
  });
}
