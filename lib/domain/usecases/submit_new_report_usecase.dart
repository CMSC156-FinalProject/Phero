import 'package:uuid/uuid.dart';
import '../models/report.dart';
import '../repositories/report_repository.dart';
import '../repositories/location_service.dart';
import '../repositories/camera_service.dart';
import '../repositories/auth_repository.dart';
import '../repositories/storage_service.dart';

class SubmitNewReportUseCase {
  final ReportRepository _reportRepository;
  final LocationService _locationService;
  final CameraService _cameraService;
  final AuthRepository _authRepository;
  final StorageService _storageService;
  final Uuid _uuid = const Uuid();

  SubmitNewReportUseCase(
    this._reportRepository,
    this._locationService,
    this._cameraService,
    this._authRepository,
    this._storageService,
  );

  Future<void> execute({
    required String title,
    required String description,
    bool capturePhoto = false,
    String? localImagePath,
    double? latitude,
    double? longitude,
  }) async {
    // 1. Get current authenticated user
    final user = await _authRepository.getCurrentUser();
    if (user == null) {
      throw Exception('User must be logged in to submit a report.');
    }

    // 2. Get current location
    double lat;
    double lon;
    if (latitude != null && longitude != null) {
      lat = latitude;
      lon = longitude;
    } else {
      final location = await _locationService.getCurrentLocation();
      if (location == null) {
        throw Exception('Could not determine current location. Please ensure location services are enabled.');
      }
      lat = location.latitude;
      lon = location.longitude;
    }

    final reportId = _uuid.v4();

    // 3. Optionally capture media and upload
    String? mediaUrl;
    if (localImagePath != null && localImagePath.isNotEmpty) {
      mediaUrl = await _storageService.uploadReportImage(user.id, reportId, localImagePath);
    } else if (capturePhoto) {
      final media = await _cameraService.takePicture();
      if (media != null) {
        mediaUrl = await _storageService.uploadReportImage(user.id, reportId, media.path);
      }
    }

    // 4. Construct Report
    final report = Report(
      id: reportId,
      title: title,
      description: description,
      userId: user.id,
      timestamp: DateTime.now(),
      latitude: lat,
      longitude: lon,
      mediaPath: mediaUrl,
      status: 'pending',
    );

    // 5. Submit to Repository
    await _reportRepository.createReport(report);
  }
}
