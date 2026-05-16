import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/report.dart';
import '../../domain/repositories/report_repository.dart';

class ReportRepositoryImpl implements ReportRepository {
  final FirebaseFirestore _firestore;

  ReportRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<void> createReport(Report report) async {
    await _firestore
        .collection('reports')
        .doc(report.id)
        .set(report.toJson());
  }

  @override
  Future<List<Report>> getReports() async {
    final snapshot = await _firestore
        .collection('reports')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<List<Report>> getUserReports(String userId) async {
    final snapshot = await _firestore
        .collection('reports')
        .where('userId', isEqualTo: userId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => Report.fromJson(doc.data()))
        .toList();
  }

  @override
  Future<void> updateReportStatus(String reportId, String newStatus) async {
    await _firestore
        .collection('reports')
        .doc(reportId)
        .update({'status': newStatus});
  }
}
