import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

abstract class CartEvent {}

class LoadCartRequested extends CartEvent {}

class AddCartItemRequested extends CartEvent {
  final MenuItemModel item;
  AddCartItemRequested(this.item);
}

class DecrementCartItemRequested extends CartEvent {
  final MenuItemModel item;
  DecrementCartItemRequested(this.item);
}

class RemoveCartItemRequested extends CartEvent {
  final MenuItemModel item;
  RemoveCartItemRequested(this.item);
}

class ClearCartRequested extends CartEvent {}
