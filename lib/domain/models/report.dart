class Report {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String? mediaPath;
  final String status;

  Report({
    required this.id,
    required this.title,
    required this.description,
    required this.userId,
    required this.timestamp,
    required this.latitude,
    required this.longitude,
    this.mediaPath,
    required this.status,
  });

  factory Report.fromJson(Map<String, dynamic> json) {
    return Report(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      userId: json['userId'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      mediaPath: json['mediaPath'] as String?,
      status: json['status'] as String? ?? 'pending',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'userId': userId,
      'timestamp': timestamp.toIso8601String(),
      'latitude': latitude,
      'longitude': longitude,
      'mediaPath': mediaPath,
      'status': status,
    };
  }
}
