class ReportModel {
  final String id;
  final String title;
  final String category;
  final String description;
  final String location;
  final String? imageUrl;
  final String status;
  final String userId;
  final DateTime createdAt;

  ReportModel({
    required this.id,
    required this.title,
    required this.category,
    required this.description,
    required this.location,
    this.imageUrl,
    required this.status,
    required this.userId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'location': location,
      'imageUrl': imageUrl,
      'status': status,
      'userId': userId,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory ReportModel.fromMap(String id, Map<String, dynamic> map) {
    return ReportModel(
      id: id,
      title: map['title'] ?? '',
      category: map['category'] ?? '',
      description: map['description'] ?? '',
      location: map['location'] ?? '',
      imageUrl: map['imageUrl'],
      status: map['status'] ?? 'REPORTED',
      userId: map['userId'] ?? '',
      createdAt: map['createdAt'] != null ? DateTime.parse(map['createdAt']) : DateTime.now(),
    );
  }
}