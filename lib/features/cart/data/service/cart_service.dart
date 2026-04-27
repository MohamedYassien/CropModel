import 'package:cropmodel/features/Menu/data/model/menu_model.dart';
import '../model/cart_item.dart';

class CartService {
  static final CartService _instance = CartService._();
  CartService._();
  factory CartService() => _instance;

  final List<CartItem> _items = [];

  String _key(MenuItemModel item, {String? notes}) {
    return '${item.name}|${item.price}|${item.imageUrl}|${notes ?? ""}';
  }

  List<CartItem> getItems() => List.unmodifiable(_items);

  void addItem(MenuItemModel item, {String? notes}) {
    final index = _items.indexWhere((e) =>
    _key(e.item, notes: e.notes) == _key(item, notes: notes));

    if (index >= 0) {
      _items[index] =
          _items[index].copyWith(quantity: _items[index].quantity + 1);
      return;
    }

    _items.add(CartItem(item: item, quantity: 1, notes: notes));
  }

  void decrementItem(MenuItemModel item, {String? notes}) {
    final index = _items.indexWhere((e) =>
    _key(e.item, notes: e.notes) == _key(item, notes: notes));

    if (index < 0) return;

    final current = _items[index];
    final nextQty = current.quantity - 1;

    if (nextQty <= 0) {
      _items.removeAt(index);
    } else {
      _items[index] = current.copyWith(quantity: nextQty);
    }
  }

  void updateItemNotes(MenuItemModel item, String? newNotes, {String? oldNotes}) {
    final index = _items.indexWhere((e) =>
    _key(e.item, notes: e.notes) == _key(item, notes: oldNotes));

    if (index < 0) return;

    _items[index] = _items[index].copyWith(notes: newNotes);
  }

  void removeItem(MenuItemModel item, {String? notes}) {
    _items.removeWhere((e) =>
    _key(e.item, notes: e.notes) == _key(item, notes: notes));
  }

  void clear() => _items.clear();

  double getTotal() =>
      _items.fold(0, (sum, e) => sum + e.totalPrice);
}