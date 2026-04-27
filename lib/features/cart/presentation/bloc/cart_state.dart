import '../../data/model/cart_item.dart';

abstract class CartState {}

class CartInitial extends CartState {}

class CartLoaded extends CartState {
  final List<CartItem> items;
  final double total;

  CartLoaded({required this.items, required this.total});
}
