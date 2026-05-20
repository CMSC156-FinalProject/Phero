import '../models/app_user.dart';

abstract class AuthRepository {
  Future<AppUser?> getCurrentUser();
  Future<AppUser?> signInWithEmailAndPassword(String email, String password);
  Future<AppUser?> createUserWithEmailAndPassword(String email, String password, String? displayName);
  Future<void> signOut();
  Stream<AppUser?> get userChanges;
}
