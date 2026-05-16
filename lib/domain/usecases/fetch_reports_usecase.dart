import '../models/report.dart';
import '../repositories/report_repository.dart';

class FetchReportsUseCase {
  final ReportRepository _reportRepository;

  FetchReportsUseCase(this._reportRepository);

  /// Fetches all reports.
  Future<List<Report>> execute() async {
    return await _reportRepository.getReports();
  }

  /// Fetches reports for a specific user.
  Future<List<Report>> executeForUser(String userId) async {
    return await _reportRepository.getUserReports(userId);
  }
}
