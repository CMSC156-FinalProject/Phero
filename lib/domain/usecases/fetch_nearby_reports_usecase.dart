import '../models/report.dart';
import '../repositories/report_repository.dart';

class FetchNearbyReportsUseCase {
  final ReportRepository _reportRepository;

  FetchNearbyReportsUseCase(this._reportRepository);

  /// Fetches reports within a specified radius from the given coordinates.
  Future<List<Report>> execute({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    return await _reportRepository.getReportsNearby(
      latitude: latitude,
      longitude: longitude,
      radiusInKm: radiusInKm,
    );
  }
}
