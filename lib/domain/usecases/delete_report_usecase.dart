import '../repositories/report_repository.dart';

class DeleteReportUseCase {
  final ReportRepository _reportRepository;

  DeleteReportUseCase(this._reportRepository);

  /// Deletes a specific report by ID.
  Future<void> execute(String reportId) async {
    await _reportRepository.deleteReport(reportId);
  }
}
