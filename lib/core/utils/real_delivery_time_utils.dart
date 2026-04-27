import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RealDeliveryTimeUtils {
  static const double averageDeliverySpeedKmh = 30.0; // Average delivery speed in km/h
  static const double preparationTimeMinutes = 15.0; // Food preparation time
  static const double bufferTimeMinutes = 5.0; // Buffer time for delays

  /// Calculate distance between two points in kilometers
  static double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    const double earthRadiusKm = 6371.0;
    
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    
    double a = sin(dLat / 2) * sin(dLat / 2) +
               cos(_toRadians(lat1)) * cos(_toRadians(lat2)) *
               sin(dLon / 2) * sin(dLon / 2);
    double c = 2 * atan2(sqrt(a), sqrt(1 - a));
    
    return earthRadiusKm * c;
  }

  static double _toRadians(double degrees) {
    return degrees * (pi / 180);
  }

  /// Get current user location
  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check location permissions
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return null;
    }

    // Get current position
    try {
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10),
      );
    } catch (e) {
      return null;
    }
  }

  /// Calculate estimated delivery time based on real location
  static Future<String> calculateRealDeliveryTime(double restaurantLat, double restaurantLng) async {
    final userPosition = await getCurrentLocation();
    
    if (userPosition == null) {
      // Fallback to estimated time if location is not available
      return _generateEstimatedTime();
    }

    final distanceKm = calculateDistance(
      userPosition.latitude,
      userPosition.longitude,
      restaurantLat,
      restaurantLng,
    );

    // Calculate travel time in minutes
    final travelTimeMinutes = (distanceKm / averageDeliverySpeedKmh) * 60;
    
    // Total time = preparation time + travel time + buffer
    final totalTime = preparationTimeMinutes + travelTimeMinutes + bufferTimeMinutes;
    
    // Fixed time based on distance - no random variation
    final minTime = max(15, totalTime - 5);
    final maxTime = totalTime + 5;

    return '${minTime.round()}–${maxTime.round()} min';
  }

  /// Fallback method when location is not available
  static String _generateEstimatedTime() {
    // Fixed fallback time - no random variation
    return '25–40 min';
  }

  /// Get distance in user-friendly format
  static Future<String> getDistanceText(double restaurantLat, double restaurantLng) async {
    final userPosition = await getCurrentLocation();
    
    if (userPosition == null) {
      return 'Distance unavailable';
    }

    final distanceKm = calculateDistance(
      userPosition.latitude,
      userPosition.longitude,
      restaurantLat,
      restaurantLng,
    );

    if (distanceKm < 1) {
      return '${(distanceKm * 1000).round()} m away';
    } else {
      return '${distanceKm.toStringAsFixed(1)} km away';
    }
  }
}
