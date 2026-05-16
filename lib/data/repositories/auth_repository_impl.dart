import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/app_user.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;

  AuthRepositoryImpl({FirebaseAuth? firebaseAuth, FirebaseFirestore? firestore})
      : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance;

  Future<AppUser?> _fetchUserWithRole(User? user) async {
    if (user == null) {
      return null;
    }
    
    try {
      final doc = await _firestore.collection('users').doc(user.uid).get();
      if (doc.exists && doc.data() != null) {
        return AppUser.fromJson(doc.data()!);
      }
    } catch (e) {
      // If fetching fails, fallback to basic user
    }

    return AppUser(
      id: user.uid,
      email: user.email ?? '',
      displayName: user.displayName,
      role: 'user', // Default fallback
    );
  }

  @override
  Future<AppUser?> getCurrentUser() async {
    final user = _firebaseAuth.currentUser;
    return _fetchUserWithRole(user);
  }

  @override
  Future<AppUser?> signInWithEmailAndPassword(
      String email, String password) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return _fetchUserWithRole(credential.user);
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
      
      // Update display name in Firebase Auth
      if (displayName != null && credential.user != null) {
        await credential.user!.updateDisplayName(displayName);
        // Reload user to get updated data
        await credential.user!.reload();
      }

      final currentUser = _firebaseAuth.currentUser;
      if (currentUser != null) {
        final appUser = AppUser(
          id: currentUser.uid,
          email: currentUser.email ?? email,
          displayName: displayName,
          role: 'user',
        );

        // Save to Firestore
        await _firestore.collection('users').doc(currentUser.uid).set(appUser.toJson());
        return appUser;
      }
      return null;
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
