import 'dart:math';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class RealDeliveryTimeUtils {
  static const double averageDeliverySpeedKmh = 30.0;
  static const double preparationTimeMinutes = 15.0;
  static const double bufferTimeMinutes = 5.0;

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

  static Future<Position?> getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    // Check location permissions (don't request, just check)
    permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied || 
        permission == LocationPermission.deniedForever) {
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

  static Future<String> calculateRealDeliveryTime(double restaurantLat, double restaurantLng) async {
    final userPosition = await getCurrentLocation();
    
    if (userPosition == null) {
      return _generateEstimatedTime();
    }

    final distanceKm = calculateDistance(
      userPosition.latitude,
      userPosition.longitude,
      restaurantLat,
      restaurantLng,
    );

    final travelTimeMinutes = (distanceKm / averageDeliverySpeedKmh) * 60;
    
    final totalTime = preparationTimeMinutes + travelTimeMinutes + bufferTimeMinutes;
    
    final minTime = max(15, totalTime - 5);
    final maxTime = totalTime + 5;

    return '${minTime.round()}–${maxTime.round()} min';
  }

  static String _generateEstimatedTime() {
    return '25–40 min';
  }

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
