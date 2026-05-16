import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';
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

  @override
  Future<List<Report>> getReportsNearby({
    required double latitude,
    required double longitude,
    required double radiusInKm,
  }) async {
    final geoFirePoint = GeoFirePoint(GeoPoint(latitude, longitude));

    final stream = GeoCollectionReference<Map<String, dynamic>>(
      _firestore.collection('reports'),
    ).subscribeWithin(
      center: geoFirePoint,
      radiusInKm: radiusInKm,
      field: 'geoHash',
      geopointFrom: (data) => GeoPoint(data['latitude'] as double, data['longitude'] as double),
      strictMode: true,
    );

    // We get the first emission from the stream.
    // In a real application, you might want to return the Stream directly for realtime updates.
    final snapshots = await stream.first;

    return snapshots
        .map((snapshot) => Report.fromJson(snapshot.data()!))
        .toList();
  }
}
