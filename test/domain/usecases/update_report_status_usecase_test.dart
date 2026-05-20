import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:phero_app/domain/usecases/update_report_status_usecase.dart';
import 'package:phero_app/domain/repositories/report_repository.dart';

// this tells Mockito to generate a MockReportRepository class in the update_report_status_usecase_test.mocks.dart file
@GenerateMocks([ReportRepository])
import 'update_report_status_usecase_test.mocks.dart'; // This file will be generated

void main() {
  late UpdateReportStatusUseCase useCase;
  late MockReportRepository mockRepo;

  setUp(() {
    // use the auto-generated mock class
    mockRepo = MockReportRepository();
    useCase = UpdateReportStatusUseCase(mockRepo);
  });

  test('should call updateReportStatus on the repository with correct parameters', () async {
    // arrange
    final testReportId = 'REP-1521';
    final testStatus = 'IN PROGRESS';

    // this sets up the mock to return a successful Future when updateReportStatus 
    // is called with the test parameters
    when(mockRepo.updateReportStatus(testReportId, testStatus))
        .thenAnswer((_) async {});

    // act
    await useCase.execute(testReportId, testStatus);

    // assert - verify it was called with the exact params
    verify(mockRepo.updateReportStatus(testReportId, testStatus)).called(1);
  });
}