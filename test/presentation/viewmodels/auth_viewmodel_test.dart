import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:phero_app/domain/models/app_user.dart';
import 'package:phero_app/domain/repositories/auth_repository.dart';
import 'package:phero_app/presentation/viewmodels/auth_viewmodel.dart';

class FakeAuthRepository implements AuthRepository {
  AppUser? _user;
  final StreamController<AppUser?> _userChangesController = StreamController<AppUser?>.broadcast();

  @override
  Future<AppUser?> getCurrentUser() async => _user;

  @override
  Future<AppUser?> signInWithEmailAndPassword(String email, String password) async {
    return _user;
  }

  @override
  Future<AppUser?> createUserWithEmailAndPassword(String email, String password, String? displayName) async {
    return _user;
  }

  @override
  Future<void> signOut() async {
    _user = null;
    _userChangesController.add(null);
  }

  @override
  Stream<AppUser?> get userChanges => _userChangesController.stream;

  void setUser(AppUser? user) {
    _user = user;
    _userChangesController.add(user);
  }
}

void main() {
  late AuthViewModel authViewModel;
  late FakeAuthRepository fakeAuthRepository;

  setUp(() {
    fakeAuthRepository = FakeAuthRepository();
    // AuthViewModel calls checkAuthStatus in constructor
    authViewModel = AuthViewModel(fakeAuthRepository);
  });

  group('AuthViewModel.isAdmin', () {
    test('returns false when no user is logged in', () async {
      fakeAuthRepository.setUser(null);
      await authViewModel.checkAuthStatus();
      expect(authViewModel.isAdmin, isFalse);
    });

    test('returns true when admin user is logged in', () async {
      fakeAuthRepository.setUser(AppUser(id: '1', email: 'admin@test.com', role: 'admin'));
      await authViewModel.checkAuthStatus();
      expect(authViewModel.isAdmin, isTrue);
    });

    test('returns false when regular user is logged in', () async {
      fakeAuthRepository.setUser(AppUser(id: '2', email: 'user@test.com', role: 'user'));
      await authViewModel.checkAuthStatus();
      expect(authViewModel.isAdmin, isFalse);
    });
  });
}
