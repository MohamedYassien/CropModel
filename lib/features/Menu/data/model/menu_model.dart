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
}

class MenuItemModel {
  final String name;
  final String description;
  final double price;

  MenuItemModel({required this.name, required this.description, required this.price});

  factory MenuItemModel.fromJson(Map<String, dynamic> json) {
    return MenuItemModel(
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
    );
  }
}