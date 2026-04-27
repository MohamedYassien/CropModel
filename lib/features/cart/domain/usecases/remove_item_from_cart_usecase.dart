import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

import '../../data/service/cart_service.dart';

class RemoveItemFromCartUseCase {
  final CartService _cartService;

  RemoveItemFromCartUseCase({CartService? cartService})
      : _cartService = cartService ?? CartService();

  void call(MenuItemModel item,{String? notes}) {
    _cartService.removeItem(item,notes: notes);
  }
}
