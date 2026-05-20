import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/domain/usecases/fetch_reports_usecase.dart';
import 'package:phero_app/domain/repositories/report_repository.dart';
import 'package:phero_app/domain/models/report.dart';

class FakeReportRepository implements ReportRepository {
  bool getReportsWasCalled = false;

  @override
  Future<List<Report>> getReports() async {
    getReportsWasCalled = true;
    return []; 
  }

  @override
  Future<void> createReport(Report report) async {}
  @override
  Future<List<Report>> getUserReports(String userId) async => [];
  @override
  Future<void> updateReportStatus(String reportId, String newStatus) async {}
  @override
  Future<void> deleteReport(String reportId) async {}
  @override
  Future<List<Report>> getReportsNearby({required double latitude, required double longitude, required double radiusInKm}) async => [];
}

void main() {
  late FetchReportsUseCase useCase;
  late FakeReportRepository fakeRepository;

  setUp(() {
    // initialize the fake repository and the use case before each test
    fakeRepository = FakeReportRepository();
    useCase = FetchReportsUseCase(fakeRepository);
  });

  test('should call getReports on the repository and return an empty list', () async {
    await useCase.execute();

    expect(fakeRepository.getReportsWasCalled, isTrue, reason: 'Repository method was not called!');
  });
}