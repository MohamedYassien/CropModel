class MenuCategoryModel {
  final String id;
  final String name;
  final List<MenuItemModel> items;

  MenuCategoryModel({
    required this.id,
    required this.name,
    required this.items,
  });

  factory MenuCategoryModel.fromJson(Map<String, dynamic> json) {
    return MenuCategoryModel(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      items: (json['items'] as List?)
          ?.map((i) => MenuItemModel.fromJson(i))
          .toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class MenuItemModel {
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final String? notes;


  MenuItemModel({
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.notes,
  });

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      notes: json['notes'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'notes': notes,
    };
  }
}