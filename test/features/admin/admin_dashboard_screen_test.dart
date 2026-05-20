import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:phero_app/features/admin/admin_dashboard_screen.dart';
import 'package:phero_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:phero_app/presentation/viewmodels/report_viewmodel.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:phero_app/domain/repositories/auth_repository.dart';
import 'package:phero_app/domain/usecases/submit_new_report_usecase.dart';
import 'package:phero_app/domain/usecases/fetch_reports_usecase.dart';
import 'package:phero_app/domain/usecases/fetch_nearby_reports_usecase.dart';
import 'package:phero_app/domain/usecases/update_report_status_usecase.dart';
import 'package:phero_app/domain/usecases/delete_report_usecase.dart';
import 'package:phero_app/domain/models/app_user.dart';

import 'package:phero_app/core/theme/theme_notifier.dart';

@GenerateMocks([
  AuthRepository,
  SubmitNewReportUseCase,
  FetchReportsUseCase,
  FetchNearbyReportsUseCase,
  UpdateReportStatusUseCase,
  DeleteReportUseCase,
])
import 'admin_dashboard_screen_test.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late MockSubmitNewReportUseCase mockSubmitNewReportUseCase;
  late MockFetchReportsUseCase mockFetchReportsUseCase;
  late MockFetchNearbyReportsUseCase mockFetchNearbyReportsUseCase;
  late MockUpdateReportStatusUseCase mockUpdateReportStatusUseCase;
  late MockDeleteReportUseCase mockDeleteReportUseCase;

  late AuthViewModel authViewModel;
  late ReportViewModel reportViewModel;
  late ThemeNotifier themeNotifier;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    mockSubmitNewReportUseCase = MockSubmitNewReportUseCase();
    mockFetchReportsUseCase = MockFetchReportsUseCase();
    mockFetchNearbyReportsUseCase = MockFetchNearbyReportsUseCase();
    mockUpdateReportStatusUseCase = MockUpdateReportStatusUseCase();
    mockDeleteReportUseCase = MockDeleteReportUseCase();

    when(mockAuthRepository.userChanges).thenAnswer(
      (_) => const Stream.empty(),
    );

    authViewModel = AuthViewModel(mockAuthRepository);
    reportViewModel = ReportViewModel(
      submitNewReportUseCase: mockSubmitNewReportUseCase,
      fetchReportsUseCase: mockFetchReportsUseCase,
      fetchNearbyReportsUseCase: mockFetchNearbyReportsUseCase,
      updateReportStatusUseCase: mockUpdateReportStatusUseCase,
      deleteReportUseCase: mockDeleteReportUseCase,
    );
    themeNotifier = ThemeNotifier();
  });

  Widget createWidgetUnderTest() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>.value(value: authViewModel),
        ChangeNotifierProvider<ReportViewModel>.value(value: reportViewModel),
        ChangeNotifierProvider<ThemeNotifier>.value(value: themeNotifier),
      ],
      child: const MaterialApp(
        home: AdminDashboardScreen(),
      ),
    );
  }

  testWidgets('displays Access Denied when user is not admin', (tester) async {
    when(mockAuthRepository.getCurrentUser()).thenAnswer(
      (_) async => AppUser(id: '1', email: 'test@test.com', displayName: 'User', role: 'user'),
    );

    await authViewModel.checkAuthStatus();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Access Denied'), findsOneWidget);
  });

  testWidgets('displays Admin Dashboard when user is admin', (tester) async {
    when(mockAuthRepository.getCurrentUser()).thenAnswer(
      (_) async => AppUser(id: '1', email: 'admin@test.com', displayName: 'Admin', role: 'admin'),
    );
    when(mockFetchReportsUseCase.execute()).thenAnswer((_) async => []);

    await authViewModel.checkAuthStatus();
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump();

    expect(find.text('Admin Dashboard'), findsOneWidget);
    expect(find.text('Pending'), findsOneWidget);
    expect(find.text('In Progress'), findsOneWidget);
    expect(find.text('Closed'), findsOneWidget);
  });
}
