import 'dart:convert';
import 'package:flutter/services.dart';
import '../model/restaurant_model.dart';

class RestaurantService {
  static const String _assetPath = 'assets/data/restaurants.json';

  Future<List<RestaurantModel>> getRestaurants() async {
    try {
      final String jsonString = await rootBundle.loadString(_assetPath);
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      final List<dynamic> restaurantsJson = jsonData['restaurants'];

      return restaurantsJson
          .map((json) => RestaurantModel.fromJson(json))
          .toList();
    } catch (e) {
      throw Exception('Failed to load restaurants: $e');
    }
  }

  Future<RestaurantModel> getRestaurantById(String id) async {
    try {
      final restaurants = await getRestaurants();
      return restaurants.firstWhere(
            (r) => r.id == id,
        orElse: () => throw Exception('Restaurant not found'),
      );
    } catch (e) {
      throw Exception('Failed to get restaurant details: $e');
    }
  }
}