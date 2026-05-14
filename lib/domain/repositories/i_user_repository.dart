import '../models/user_model.dart';

abstract class IUserRepository {
  /// Create a new user document
  Future<void> createUser(UserModel user);
  
  /// Read a user document by their ID
  Future<UserModel?> getUser(String uid);
  
  /// Update specific fields of a user document
  Future<void> updateUser(String uid, Map<String, dynamic> data);
  
  /// Delete a user document
  Future<void> deleteUser(String uid);
}