import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

class CartItem {
  final MenuItemModel item;
  final int quantity;
  final String? notes;

  const CartItem({
    required this.item,
    required this.quantity,
    this.notes,
  });

  CartItem copyWith({
    MenuItemModel? item,
    int? quantity,
    String? notes,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
      notes: notes ?? this.notes,
    );
  }

  double get totalPrice => item.price * quantity;
}
