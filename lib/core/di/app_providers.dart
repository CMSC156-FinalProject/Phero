import 'package:flutter/material.dart';
import '../../presentation/viewmodels/auth_viewmodel.dart';
import '../../presentation/viewmodels/report_viewmodel.dart';

class AppProviders extends InheritedWidget {
  final AuthViewModel authViewModel;
  final ReportViewModel reportViewModel;

  const AppProviders({
    super.key,
    required this.authViewModel,
    required this.reportViewModel,
    required super.child,
  });

  static AppProviders of(BuildContext context) {
    final AppProviders? result = context.dependOnInheritedWidgetOfExactType<AppProviders>();
    assert(result != null, 'No AppProviders found in context');
    return result!;
  }

  @override
  bool updateShouldNotify(AppProviders oldWidget) => false;
}