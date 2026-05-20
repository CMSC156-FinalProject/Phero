class AppUser {
  final String id;
  final String email;
  final String? displayName;
  final String role;

  AppUser({
    required this.id,
    required this.email,
    this.displayName,
    this.role = 'user',
  });

  bool get isAdmin => role == 'admin';

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id'] as String? ?? '',
      email: json['email'] as String? ?? '',
      displayName: json['displayName'] as String?,
      role: json['role'] as String? ?? 'user',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'role': role,
    };
  }
}
