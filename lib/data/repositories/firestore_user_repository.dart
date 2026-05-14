import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/i_user_repository.dart';
import '../../domain/models/user_model.dart';

class FirestoreUserRepository implements IUserRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionPath = 'users';

  // --- WRITE ---
  @override
  Future<void> createUser(UserModel user) async {
    try {
      await _firestore
          .collection(_collectionPath)
          .doc(user.id)
          .set(user.toMap());
    } on FirebaseException catch (e) {
      throw Exception("Firestore Error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to create user: $e");
    }
  }

  // --- READ ---
  @override
  Future<UserModel?> getUser(String uid) async {
    try {
      DocumentSnapshot doc = 
          await _firestore.collection(_collectionPath).doc(uid).get();
      
      if (doc.exists && doc.data() != null) {
        return UserModel.fromMap(doc.id, doc.data() as Map<String, dynamic>);
      }
      return null; // User not found
    } on FirebaseException catch (e) {
      throw Exception("Firestore Error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to fetch user: $e");
    }
  }

  // --- UPDATE ---
  @override
  Future<void> updateUser(String uid, Map<String, dynamic> data) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).update(data);
    } on FirebaseException catch (e) {
      throw Exception("Firestore Error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to update user: $e");
    }
  }

  // --- DELETE ---
  @override
  Future<void> deleteUser(String uid) async {
    try {
      await _firestore.collection(_collectionPath).doc(uid).delete();
    } on FirebaseException catch (e) {
      throw Exception("Firestore Error: ${e.message}");
    } catch (e) {
      throw Exception("Failed to delete user: $e");
    }
  }
}