import '../repositories/report_repository.dart';

class UpdateReportStatusUseCase {
  final ReportRepository _reportRepository;

  UpdateReportStatusUseCase(this._reportRepository);

  /// Updates the status of a specific report.
  Future<void> execute(String reportId, String newStatus) async {
    await _reportRepository.updateReportStatus(reportId, newStatus);
  }
}
