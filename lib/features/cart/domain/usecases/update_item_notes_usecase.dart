import '../../data/service/cart_service.dart';
import '../../../Menu/data/model/menu_model.dart';

class UpdateItemNotesUseCase {
  final CartService _cartService = CartService();

  void call(MenuItemModel item, String? notes, {String? oldNotes}) {
    _cartService.updateItemNotes(item, notes, oldNotes: oldNotes);
  }
}