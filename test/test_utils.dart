import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phero_app/core/theme/theme_notifier.dart';
import 'package:phero_app/presentation/viewmodels/auth_viewmodel.dart';
import 'package:phero_app/presentation/viewmodels/report_viewmodel.dart';
import 'package:phero_app/domain/repositories/auth_repository.dart';
import 'package:phero_app/domain/repositories/report_repository.dart';
import 'package:phero_app/domain/repositories/location_service.dart';
import 'package:phero_app/domain/repositories/camera_service.dart';
import 'package:phero_app/domain/repositories/storage_service.dart';
import 'package:phero_app/domain/usecases/submit_new_report_usecase.dart';
import 'package:phero_app/domain/usecases/fetch_reports_usecase.dart';
import 'package:phero_app/domain/usecases/fetch_nearby_reports_usecase.dart';
import 'package:phero_app/domain/usecases/update_report_status_usecase.dart';
import 'package:phero_app/domain/usecases/delete_report_usecase.dart';
import 'package:phero_app/domain/models/app_user.dart';
import 'package:phero_app/domain/models/report.dart';
import 'package:phero_app/domain/models/location_data.dart';
import 'package:phero_app/domain/models/captured_media.dart';

class MockAuthRepository implements AuthRepository {
  @override
  Future<AppUser?> getCurrentUser() async => null;
  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    return AppUser(id: '1', email: email, displayName: 'Test User');
  }
  @override
  Future<AppUser?> createUserWithEmailAndPassword(String email, String password, String? displayName) async {
    return AppUser(id: '1', email: email, displayName: displayName);
  }
  @override
  Future<void> signOut() async {}
  @override
  Stream<AppUser?> get userChanges => const Stream.empty();
}

class MockReportRepository implements ReportRepository {
  @override
  Future<void> createReport(Report report) async {}
  @override
  Future<List<Report>> getReports() async => [];
  @override
  Future<List<Report>> getUserReports(String userId) async => [];
  @override
  Future<List<Report>> getReportsNearby({required double latitude, required double longitude, required double radiusInKm}) async => [];
  @override
  Future<void> updateReportStatus(String reportId, String newStatus) async {}
  @override
  Future<void> deleteReport(String reportId) async {}
}

class MockLocationService implements LocationService {
  @override
  Future<bool> checkAndRequestPermissions() async => true;
  @override
  Future<LocationData?> getCurrentLocation() async => LocationData(latitude: 0, longitude: 0);
}

class MockCameraService implements CameraService {
  @override
  Future<CapturedMedia?> takePicture() async => null;
}

class MockStorageService implements StorageService {
  @override
  Future<String?> uploadReportImage(String userId, String reportId, String filePath) async => null;
}

Widget createTestableWidget({
  required Widget child,
  ThemeNotifier? themeNotifier,
  AuthViewModel? authViewModel,
  ReportViewModel? reportViewModel,
}) {
  final authRepo = MockAuthRepository();
  final reportRepo = MockReportRepository();
  final locationService = MockLocationService();
  final cameraService = MockCameraService();
  final storageService = MockStorageService();

  final submitUseCase = SubmitNewReportUseCase(reportRepo, locationService, cameraService, authRepo, storageService);
  final fetchUseCase = FetchReportsUseCase(reportRepo);
  final fetchNearbyUseCase = FetchNearbyReportsUseCase(reportRepo);
  final updateUseCase = UpdateReportStatusUseCase(reportRepo);
  final deleteUseCase = DeleteReportUseCase(reportRepo);

  return MultiProvider(
    providers: [
      ChangeNotifierProvider<ThemeNotifier>(
        create: (_) => themeNotifier ?? ThemeNotifier(),
      ),
      ChangeNotifierProvider<AuthViewModel>(
        create: (_) => authViewModel ?? AuthViewModel(authRepo),
      ),
      ChangeNotifierProvider<ReportViewModel>(
        create: (_) => reportViewModel ?? ReportViewModel(
          submitNewReportUseCase: submitUseCase,
          fetchReportsUseCase: fetchUseCase,
          fetchNearbyReportsUseCase: fetchNearbyUseCase,
          updateReportStatusUseCase: updateUseCase,
          deleteReportUseCase: deleteUseCase,
        ),
      ),
      Provider<LocationService>(create: (_) => locationService),
    ],
    child: MaterialApp(
      home: child,
      // For navigation tests
      onGenerateRoute: (settings) {
        return MaterialPageRoute(builder: (context) => Scaffold(body: Text(settings.name ?? '')));
      },
    ),
  );
}
