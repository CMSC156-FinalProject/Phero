class UserModel {
  final String id;
  final String name;
  final String email;

  UserModel({
    required this.id, 
    required this.name, 
    required this.email
  });

  // Convert UserModel to a Map to save to Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
    };
  }

  // Create a UserModel from a Firestore Document snapshot
  factory UserModel.fromMap(String id, Map<String, dynamic> map) {
    return UserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
    );
  }
}