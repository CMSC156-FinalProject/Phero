import 'package:uuid/uuid.dart';
import '../models/report.dart';
import '../repositories/report_repository.dart';
import '../repositories/location_service.dart';
import '../repositories/camera_service.dart';
import '../repositories/auth_repository.dart';

class SubmitNewReportUseCase {
  final ReportRepository _reportRepository;
  final LocationService _locationService;
  final CameraService _cameraService;
  final AuthRepository _authRepository;
  final Uuid _uuid = const Uuid();

  SubmitNewReportUseCase(
    this._reportRepository,
    this._locationService,
    this._cameraService,
    this._authRepository,
  );

  /// Executes the use case to submit a new report.
  /// Optionally takes a boolean to capture a photo during submission.
  Future<void> execute({
    required String title,
    required String description,
    bool capturePhoto = false,
  }) async {
    // 1. Get current authenticated user
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('User must be logged in to submit a report.');
    }

    // 2. Get current location
    final location = await _locationService.getCurrentLocation();
    if (location == null) {
      throw Exception('Could not determine current location. Please ensure location services are enabled.');
    }

    // 3. Optionally capture media
    String? mediaPath;
    if (capturePhoto) {
      final media = await _cameraService.takePicture();
      mediaPath = media?.path;
    }

    // 4. Construct Report
    final report = Report(
      id: _uuid.v4(),
      title: title,
      description: description,
      userId: user.id,
      timestamp: DateTime.now(),
      latitude: location.latitude,
      longitude: location.longitude,
      mediaPath: mediaPath,
      status: 'pending',
    );

    // 5. Submit to Repository
    await _reportRepository.createReport(report);
  }
}
