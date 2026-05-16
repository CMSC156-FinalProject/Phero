import '../models/report.dart';

abstract class ReportRepository {
  Future<void> createReport(Report report);
  Future<List<Report>> getReports();
  Future<List<Report>> getUserReports(String userId);
  Future<void> updateReportStatus(String reportId, String newStatus);
  Future<void> deleteReport(String reportId);
  Future<List<Report>> getReportsNearby({required double latitude, required double longitude, required double radiusInKm});
}
