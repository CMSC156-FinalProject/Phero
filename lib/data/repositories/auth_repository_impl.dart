import 'package:firebase_auth/firebase_auth.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  AppUser? _userFromFirebase(User? user) {
    if (user == null) {
      return null;
    }
    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
    );
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return _userFromFirebase(user);
  }

  @override
  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _userFromFirebase(credential.user);
    } catch (e) {
      // In a real app, handle specific FirebaseAuthException codes here
      rethrow;
    }
  }

  @override
  Future<AppUser?> createUserWithEmailAndPassword(
      String email, String password, String? displayName) async {
    try {
      final credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Update display name if provided
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        // Reload user to get updated data
        await credential.user!.reload();
        return _userFromFirebase(_firebaseAuth.currentUser);
      }
      
      return _userFromFirebase(credential.user);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
