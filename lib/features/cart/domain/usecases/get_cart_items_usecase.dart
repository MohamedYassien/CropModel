import '../../data/model/cart_item.dart';
import '../../data/service/cart_service.dart';

class GetCartItemsUseCase {
  final CartService _cartService;

  GetCartItemsUseCase({CartService? cartService})
      : _cartService = cartService ?? CartService();

  List<CartItem> call() {
    return _cartService.getItems();
  }
}
