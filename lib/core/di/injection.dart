import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

// Repositories & Services
import '../../domain/repositories/auth_repository.dart';
import '../../domain/repositories/report_repository.dart';
import '../../domain/repositories/location_service.dart';
import '../../domain/repositories/camera_service.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../data/repositories/report_repository_impl.dart';
import '../../data/services/location_service_impl.dart';
import '../../data/services/camera_service_impl.dart';

// Use Cases
import '../../domain/usecases/submit_new_report_usecase.dart';
import '../../domain/usecases/fetch_reports_usecase.dart';
import '../../domain/usecases/fetch_nearby_reports_usecase.dart';
import '../../domain/usecases/update_report_status_usecase.dart';
import '../../domain/usecases/delete_report_usecase.dart';

// ViewModels
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/report_viewmodel.dart';

class InjectionContainer {
  static List<SingleChildWidget> getProviders() {
    return [
      // 1. Independent Services & Repositories
      Provider<LocationService>(create: (_) => LocationServiceImpl()),
      Provider<CameraService>(create: (_) => CameraServiceImpl()),
      Provider<AuthRepository>(create: (_) => AuthRepositoryImpl()),
      Provider<ReportRepository>(create: (_) => ReportRepositoryImpl()),

      // 2. Use Cases (Depend on Repositories/Services)
      ProxyProvider4<ReportRepository, LocationService, CameraService, AuthRepository, SubmitNewReportUseCase>(
        update: (context, reportRepo, locationService, cameraService, authRepo, previous) => SubmitNewReportUseCase(
          reportRepo,
          locationService,
          cameraService,
          authRepo,
        ),
      ),
      ProxyProvider<ReportRepository, FetchReportsUseCase>(
        update: (context, reportRepo, previous) => FetchReportsUseCase(reportRepo),
      ),
      ProxyProvider<ReportRepository, FetchNearbyReportsUseCase>(
        update: (context, reportRepo, previous) => FetchNearbyReportsUseCase(reportRepo),
      ),
      ProxyProvider<ReportRepository, UpdateReportStatusUseCase>(
        update: (context, reportRepo, previous) => UpdateReportStatusUseCase(reportRepo),
      ),
      ProxyProvider<ReportRepository, DeleteReportUseCase>(
        update: (context, reportRepo, previous) => DeleteReportUseCase(reportRepo),
      ),

      // 3. ViewModels (Depend on Use Cases & Repositories)
      ChangeNotifierProxyProvider<AuthRepository, AuthViewModel>(
        create: (context) => AuthViewModel(context.read<AuthRepository>()),
        update: (context, authRepo, previous) => previous ?? AuthViewModel(authRepo),
      ),
      ChangeNotifierProxyProvider5<SubmitNewReportUseCase, FetchReportsUseCase, FetchNearbyReportsUseCase, UpdateReportStatusUseCase, DeleteReportUseCase, ReportViewModel>(
        create: (context) => ReportViewModel(
          submitNewReportUseCase: context.read<SubmitNewReportUseCase>(),
          fetchReportsUseCase: context.read<FetchReportsUseCase>(),
          fetchNearbyReportsUseCase: context.read<FetchNearbyReportsUseCase>(),
          updateReportStatusUseCase: context.read<UpdateReportStatusUseCase>(),
          deleteReportUseCase: context.read<DeleteReportUseCase>(),
        ),
        update: (context, submitUseCase, fetchUseCase, fetchNearbyUseCase, updateUseCase, deleteUseCase, previous) => 
          previous ?? ReportViewModel(
            submitNewReportUseCase: submitUseCase,
            fetchReportsUseCase: fetchUseCase,
            fetchNearbyReportsUseCase: fetchNearbyUseCase,
            updateReportStatusUseCase: updateUseCase,
            deleteReportUseCase: deleteUseCase,
          ),
      ),
    ];
  }
}
