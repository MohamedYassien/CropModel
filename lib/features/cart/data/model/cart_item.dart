import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

class CartItem {
  final MenuItemModel item;
  final int quantity;

  const CartItem({
    required this.item,
    required this.quantity,
  });

  CartItem copyWith({
    MenuItemModel? item,
    int? quantity,
  }) {
    return CartItem(
      item: item ?? this.item,
      quantity: quantity ?? this.quantity,
    );
  }

  double get totalPrice => item.price * quantity;
}
