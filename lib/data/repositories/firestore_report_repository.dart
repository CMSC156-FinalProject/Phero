import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../../domain/repositories/i_report_repository.dart';
import '../../domain/models/report_model.dart';

class FirestoreReportRepository implements IReportRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;
  final String _collectionPath = 'reports';

  @override
  Future<void> createReport(ReportModel report) async {
    await _firestore.collection(_collectionPath).doc(report.id).set(report.toMap());
  }

  @override
  Future<List<ReportModel>> getAllReports() async {
    final snapshot = await _firestore.collection(_collectionPath).orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => ReportModel.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<List<ReportModel>> getUserReports(String userId) async {
    final snapshot = await _firestore.collection(_collectionPath)
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .get();
    return snapshot.docs.map((doc) => ReportModel.fromMap(doc.id, doc.data())).toList();
  }

  @override
  Future<String?> uploadEvidenceImage(File imageFile, String reportId) async {
    try {
      final ref = _storage.ref().child('evidence_photos').child('$reportId.jpg');
      final uploadTask = await ref.putFile(imageFile);
      return await uploadTask.ref.getDownloadURL();
    } catch (e) {
      return null;
    }
  }
}