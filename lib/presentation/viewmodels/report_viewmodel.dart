import 'dart:io';
import 'package:flutter/material.dart';
import '../../domain/models/report_model.dart';
import '../../domain/repositories/i_report_repository.dart';
import '../../data/repositories/firestore_report_repository.dart';

class ReportViewModel extends ChangeNotifier {
  final IReportRepository _repository = FirestoreReportRepository();
  
  List<ReportModel> _allReports = [];
  List<ReportModel> _userReports = [];
  bool _isLoading = false;

  List<ReportModel> get allReports => _allReports;
  List<ReportModel> get userReports => _userReports;
  bool get isLoading => _isLoading;

  Future<void> fetchAllReports() async {
    _isLoading = true;
    notifyListeners();
    _allReports = await _repository.getAllReports();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchUserReports(String userId) async {
    _isLoading = true;
    notifyListeners();
    _userReports = await _repository.getUserReports(userId);
    _isLoading = false;
    notifyListeners();
  }

  Future<bool> submitReport({
    required String id,
    required String title,
    required String category,
    required String description,
    required String location,
    required String userId,
    File? imageFile,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      String? imageUrl;
      if (imageFile != null) {
        imageUrl = await _repository.uploadEvidenceImage(imageFile, id);
      }
      
      final report = ReportModel(
        id: id,
        title: title,
        category: category,
        description: description,
        location: location,
        imageUrl: imageUrl,
        status: 'REPORTED',
        userId: userId,
        createdAt: DateTime.now(),
      );

      await _repository.createReport(report);
      await fetchAllReports();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}