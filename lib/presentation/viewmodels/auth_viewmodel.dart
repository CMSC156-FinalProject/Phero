import 'package:flutter/foundation.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthViewModel extends ChangeNotifier {
  final AuthRepository _authRepository;

  AppUser? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthViewModel(this._authRepository) {
    checkAuthStatus();
  }

  AppUser? get currentUser => _currentUser;
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

  Future<void> checkAuthStatus() async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.getCurrentUser();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.signInWithEmailAndPassword(email, password);
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> signUp(String email, String password, String displayName) async {
    _setLoading(true);
    try {
      _currentUser = await _authRepository.createUserWithEmailAndPassword(email, password, displayName);
      _setError(null);
      return true;
    } catch (e) {
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authRepository.signOut();
      _currentUser = null;
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}
