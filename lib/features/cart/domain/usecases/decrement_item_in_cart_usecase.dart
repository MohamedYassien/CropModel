import 'package:cropmodel/features/Menu/data/model/menu_model.dart';

import '../../data/service/cart_service.dart';

class DecrementItemInCartUseCase {
  final CartService _cartService;

  DecrementItemInCartUseCase({CartService? cartService})
      : _cartService = cartService ?? CartService();

  void call(MenuItemModel item,{String? notes}) {
    _cartService.decrementItem(item,notes: notes);
  }
}
