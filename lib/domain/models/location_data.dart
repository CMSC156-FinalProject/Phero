class LocationData {
  final double latitude;
  final double longitude;
  final double? accuracy;

  LocationData({
    required this.latitude,
    required this.longitude,
    this.accuracy,
  });
}
