import '../../data/service/cart_service.dart';

class GetCartTotalUseCase {
  final CartService _cartService;

  GetCartTotalUseCase({CartService? cartService})
      : _cartService = cartService ?? CartService();

  double call() {
    return _cartService.getTotal();
  }
}
