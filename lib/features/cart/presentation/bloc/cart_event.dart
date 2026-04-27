import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

abstract class CartEvent {}

class LoadCartRequested extends CartEvent {}

class AddCartItemRequested extends CartEvent {
  final MenuItemModel item;
  final String? notes;
  AddCartItemRequested(this.item,{this.notes});


}

class DecrementCartItemRequested extends CartEvent {
  final MenuItemModel item;
  final String? notes;
  DecrementCartItemRequested(this.item,{this.notes});
}

class RemoveCartItemRequested extends CartEvent {
  final MenuItemModel item;
  final String? notes;
  RemoveCartItemRequested(this.item,{this.notes});
}

class UpdateCartItemNotesRequested extends CartEvent {
  final MenuItemModel item;
  final String? oldNotes;
  final String? newNotes;

  UpdateCartItemNotesRequested(this.item, {this.oldNotes, this.newNotes});
}

class ClearCartRequested extends CartEvent {}
