class RestaurantModel {
  final String id;
  final String name;
  final String description;
  final String location;
  final double rating;
  final String imageUrl;

  RestaurantModel({
    required this.id,
    required this.name,
    required this.description,
    required this.location,
    required this.rating,
    required this.imageUrl,
  });

  factory RestaurantModel.fromJson(Map<String, dynamic> json) {
    return RestaurantModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      location: json['location'] ?? '',
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }
}