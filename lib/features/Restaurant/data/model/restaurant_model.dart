
import '../../../Menu/data/model/menu_model.dart';

class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final double rating;
  final String imageUrl;
  final double latitude;
  final double longitude;
  final List<MenuCategoryModel> menuCategories;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.rating,
    required this.imageUrl,
    required this.latitude,
    required this.longitude,
    required this.menuCategories,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      menuCategories: (json['menuCategories'] as List?)
          ?.map((e) => MenuCategoryModel.fromJson(e))
          .toList() ??
          [],
    );
  }
}