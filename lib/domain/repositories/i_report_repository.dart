import '../models/report_model.dart';
import 'dart:io';

abstract class IReportRepository {
  Future<void> createReport(ReportModel report);
  Future<List<ReportModel>> getAllReports();
  Future<List<ReportModel>> getUserReports(String userId);
  Future<String?> uploadEvidenceImage(File imageFile, String reportId);
}