import '../models/report.dart';

abstract class ReportRepository {
  Future<void> createReport(Report report);
  Future<List<Report>> getReports();
  Future<List<Report>> getUserReports(String userId);
}
