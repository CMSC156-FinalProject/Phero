import '../models/location_data.dart';

abstract class LocationService {
  Future<bool> checkAndRequestPermissions();
  Future<LocationData?> getCurrentLocation();
}
