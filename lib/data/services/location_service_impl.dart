import 'package:geolocator/geolocator.dart';
import '../../domain/models/location_data.dart' as domain;
import '../../domain/repositories/location_service.dart';

class LocationServiceImpl implements LocationService {
  @override
  Future<bool> checkAndRequestPermissions() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return false;
    }

    return true;
  }

  @override
  Future<domain.LocationData?> getCurrentLocation() async {
    final hasPermission = await checkAndRequestPermissions();
    if (!hasPermission) {
      return null;
    }

    Position? lastKnown;
    try {
      lastKnown = await Geolocator.getLastKnownPosition();
    } catch (_) {
      // Ignore errors when fetching last known position
    }

    // Fast-path: if last known position is extremely fresh (< 1 minute), use it immediately.
    if (lastKnown != null) {
      final age = DateTime.now().difference(lastKnown.timestamp);
      if (age.inMinutes < 1) {
        return domain.LocationData(
          latitude: lastKnown.latitude,
          longitude: lastKnown.longitude,
          accuracy: lastKnown.accuracy,
        );
      }
    }

    try {
      // Main path: attempt to get high accuracy position with a 4 second timeout
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 4),
        ),
      );
      
      return domain.LocationData(
        latitude: position.latitude,
        longitude: position.longitude,
        accuracy: position.accuracy,
      );
    } catch (e) {
      // Fallback 1: use last known position even if it's older than 1 minute
      if (lastKnown != null) {
        return domain.LocationData(
          latitude: lastKnown.latitude,
          longitude: lastKnown.longitude,
          accuracy: lastKnown.accuracy,
        );
      }

      // Fallback 2: try fetching with low accuracy and 2-second timeout
      try {
        final position = await Geolocator.getCurrentPosition(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.low,
            timeLimit: Duration(seconds: 2),
          ),
        );
        return domain.LocationData(
          latitude: position.latitude,
          longitude: position.longitude,
          accuracy: position.accuracy,
        );
      } catch (_) {
        // Fallback failed
      }
      return null;
    }
  }
}
