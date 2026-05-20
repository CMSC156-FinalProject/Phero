import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire_plus/geoflutterfire_plus.dart';

class Report {
  final String id;
  final String title;
  final String description;
  final String userId;
  final DateTime timestamp;
  final double latitude;
  final double longitude;
  final String geoHash;
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
    String? geoHash,
    this.mediaPath,
    required this.status,
  }) : geoHash = geoHash ?? GeoFirePoint(GeoPoint(latitude, longitude)).geohash;

  factory Report.fromJson(Map<String, dynamic> json) {
    // Safely parse timestamp whether it's a string or Firestore Timestamp
    DateTime parsedTimestamp;
    if (json['timestamp'] is Timestamp) {
      parsedTimestamp = (json['timestamp'] as Timestamp).toDate();
    } else if (json['timestamp'] is String) {
      parsedTimestamp = DateTime.parse(json['timestamp'] as String);
    } else {
      parsedTimestamp = DateTime.now(); // Fallback
    }

    // Safely parse coordinates
    double parseDouble(dynamic val) {
      if (val is String) return double.tryParse(val) ?? 0.0;
      if (val is num) return val.toDouble();
      return 0.0;
    }

    return Report(
      id: json['id'] as String? ?? '',
      title: json['title'] as String? ?? 'Untitled',
      description: json['description'] as String? ?? '',
      userId: json['userId'] as String? ?? '',
      timestamp: parsedTimestamp,
      latitude: parseDouble(json['latitude']),
      longitude: parseDouble(json['longitude']),
      geoHash: json['geoHash'] as String?,
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
      'geoHash': geoHash,
      'mediaPath': mediaPath,
      'status': status,
    };
  }
}
