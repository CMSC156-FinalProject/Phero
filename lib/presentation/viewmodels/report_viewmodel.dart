import 'package:flutter/foundation.dart';
import '../../domain/models/report.dart';
import '../../domain/usecases/submit_new_report_usecase.dart';
import '../../domain/usecases/fetch_reports_usecase.dart';
import '../../domain/usecases/fetch_nearby_reports_usecase.dart';
import '../../domain/usecases/update_report_status_usecase.dart';

class ReportViewModel extends ChangeNotifier {
  final SubmitNewReportUseCase _submitNewReportUseCase;
  final FetchReportsUseCase _fetchReportsUseCase;
  final FetchNearbyReportsUseCase _fetchNearbyReportsUseCase;
  final UpdateReportStatusUseCase _updateReportStatusUseCase;

  List<Report> _reports = [];
  bool _isLoading = false;
  String? _errorMessage;

  ReportViewModel({
    required SubmitNewReportUseCase submitNewReportUseCase,
    required FetchReportsUseCase fetchReportsUseCase,
    required FetchNearbyReportsUseCase fetchNearbyReportsUseCase,
    required UpdateReportStatusUseCase updateReportStatusUseCase,
  })  : _submitNewReportUseCase = submitNewReportUseCase,
        _fetchReportsUseCase = fetchReportsUseCase,
        _fetchNearbyReportsUseCase = fetchNearbyReportsUseCase,
        _updateReportStatusUseCase = updateReportStatusUseCase;

  List<Report> get reports => _reports;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  Future<void> loadReports() async {
    _setLoading(true);
    try {
      _reports = await _fetchReportsUseCase.execute();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadNearbyReports(double latitude, double longitude, double radiusInKm) async {
    _setLoading(true);
    try {
      _reports = await _fetchNearbyReportsUseCase.execute(
        latitude: latitude,
        longitude: longitude,
        radiusInKm: radiusInKm,
      );
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> submitReport({required String title, required String description, bool capturePhoto = false}) async {
    _setLoading(true);
    try {
      await _submitNewReportUseCase.execute(
        title: title,
        description: description,
        capturePhoto: capturePhoto,
      );
      _setError(null);
      // Reload reports to reflect the newly added one
      await loadReports();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> updateReportStatus(String reportId, String newStatus) async {
    _setLoading(true);
    try {
      await _updateReportStatusUseCase.execute(reportId, newStatus);
      _setError(null);
      // Reload reports to reflect the updated status
      await loadReports();
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }
}
