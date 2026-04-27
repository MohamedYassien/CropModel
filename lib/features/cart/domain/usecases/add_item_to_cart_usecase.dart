import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

import '../../data/service/cart_service.dart';

class AddItemToCartUseCase {
  final CartService _cartService;

  AddItemToCartUseCase({CartService? cartService})
      : _cartService = cartService ?? CartService();

  void call(MenuItemModel item,{String? notes}) {
    _cartService.addItem(item,notes: notes);
  }
}
