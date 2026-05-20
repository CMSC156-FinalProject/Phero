import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:phero_app/domain/usecases/submit_new_report_usecase.dart';
import 'package:phero_app/domain/repositories/report_repository.dart';
import 'package:phero_app/domain/repositories/auth_repository.dart';
import 'package:phero_app/domain/repositories/location_service.dart';
import 'package:phero_app/domain/repositories/camera_service.dart';  
import 'package:phero_app/domain/repositories/storage_service.dart'; 

import 'package:phero_app/domain/models/app_user.dart';
import 'package:phero_app/domain/models/location_data.dart';
import 'package:phero_app/domain/models/report.dart';

// generate mock classes for all the dependencies of SubmitNewReportUseCase
@GenerateMocks([
  ReportRepository,
  LocationService,
  CameraService,
  AuthRepository,
  StorageService,
])
import 'submit_new_report_usecase_test.mocks.dart';

void main() {
  late SubmitNewReportUseCase useCase;
  late MockReportRepository mockReportRepo;
  late MockLocationService mockLocationService;
  late MockCameraService mockCameraService;
  late MockAuthRepository mockAuthRepo;
  late MockStorageService mockStorageService;

  // to provide a dummy Report object for any test that might need it, 
  // without having to create it in every test case
  setUpAll(() {
    provideDummy<Report>(Report(
      id: 'dummy',
      title: 'dummy',
      description: 'dummy',
      userId: 'dummy',
      timestamp: DateTime.now(),
      latitude: 0,
      longitude: 0,
      status: 'pending',
    ));
  });

  setUp(() {
    mockReportRepo = MockReportRepository();
    mockLocationService = MockLocationService();
    mockCameraService = MockCameraService();
    mockAuthRepo = MockAuthRepository();
    mockStorageService = MockStorageService();

    useCase = SubmitNewReportUseCase(
      mockReportRepo,
      mockLocationService,
      mockCameraService,
      mockAuthRepo,
      mockStorageService,
    );
  });

  group('SubmitNewReportUseCase Tests', () {
    test('Should throw Exception if user is not logged in', () async {
      // arrange - simulate no logged-in user
      when(mockAuthRepo.getCurrentUser()).thenAnswer((_) async => null);

      // act and assert - verify it throws the exact exception message
      expect(
        () => useCase.execute(title: 'Test', description: 'Test desc'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('User must be logged in'))),
      );
    });

    test('Should throw Exception if location cannot be determined', () async {
      // arrange - simulate logged-in user, but GPS is off/denied
      when(mockAuthRepo.getCurrentUser()).thenAnswer(
        (_) async => AppUser(id: '123', email: 'test@up.edu.ph', displayName: 'Test', role: 'user')
      );
      when(mockLocationService.getCurrentLocation()).thenAnswer((_) async => null);

      // act and assert
      expect(
        () => useCase.execute(title: 'Pothole', description: 'Big pothole here'),
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('ensure location services are enabled'))),
      );
    });

    test('Should successfully create a report when data is valid', () async {
      // arrange - setup all the successful mock returns
      when(mockAuthRepo.getCurrentUser()).thenAnswer(
        (_) async => AppUser(id: '123', email: 'isko@up.edu.ph', displayName: 'Isko', role: 'user')
      );
      
      when(mockLocationService.getCurrentLocation()).thenAnswer(
        (_) async => LocationData(latitude: 10.6, longitude: 122.23)
      );

      // mock the void return for creating the report
      when(mockReportRepo.createReport(any)).thenAnswer((_) async {});

      // act
      await useCase.execute(
        title: 'Broken Streetlight',
        description: 'Dark alleyway',
      );

      // assert - prove the repository was asked to save a report exactly once
      verify(mockReportRepo.createReport(any)).called(1);
    });
  });
}