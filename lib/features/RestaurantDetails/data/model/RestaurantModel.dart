import 'package:equatable/equatable.dart';

class RestaurantModel extends Equatable {
  final String id;
  final String name;
  final String imageUrl;
  final double rating;
  final String description;
  final String address;
  final double latitude;
  final double longitude;
  final List<String> menuCategories;

  const RestaurantModel({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    required this.description,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.menuCategories = const [],
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      imageUrl: json['image_url'] ?? json['imageUrl'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      description: json['description'] ?? '',
      address: json['address'] ?? '',
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      menuCategories: List<String>.from(json['menu_categories'] ?? []),
    );
  }

  @override
  List<Object?> get props => [
    id, name, imageUrl, rating, description,
    address, latitude, longitude, menuCategories
  ];
}