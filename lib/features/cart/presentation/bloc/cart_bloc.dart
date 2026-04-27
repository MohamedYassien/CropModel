import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/add_item_to_cart_usecase.dart';
import '../../domain/usecases/decrement_item_in_cart_usecase.dart';
import '../../domain/usecases/get_cart_items_usecase.dart';
import '../../domain/usecases/get_cart_total_usecase.dart';
import '../../domain/usecases/remove_item_from_cart_usecase.dart';
import '../../domain/usecases/update_item_notes_usecase.dart';
import '../../data/service/cart_service.dart';
import 'cart_event.dart';
import 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  final GetCartItemsUseCase _getCartItemsUseCase;
  final GetCartTotalUseCase _getCartTotalUseCase;
  final AddItemToCartUseCase _addItemToCartUseCase;
  final DecrementItemInCartUseCase _decrementItemInCartUseCase;
  final RemoveItemFromCartUseCase _removeItemFromCartUseCase;
  final UpdateItemNotesUseCase _updateItemNotesUseCase;
  final CartService _cartService;

  CartBloc({
    GetCartItemsUseCase? getCartItemsUseCase,
    GetCartTotalUseCase? getCartTotalUseCase,
    AddItemToCartUseCase? addItemToCartUseCase,
    DecrementItemInCartUseCase? decrementItemInCartUseCase,
    RemoveItemFromCartUseCase? removeItemFromCartUseCase,
    UpdateItemNotesUseCase? updateItemNotesUseCase,
    CartService? cartService,
  })  : _getCartItemsUseCase = getCartItemsUseCase ?? GetCartItemsUseCase(),
        _getCartTotalUseCase = getCartTotalUseCase ?? GetCartTotalUseCase(),
        _addItemToCartUseCase = addItemToCartUseCase ?? AddItemToCartUseCase(),
        _decrementItemInCartUseCase =
            decrementItemInCartUseCase ?? DecrementItemInCartUseCase(),
        _removeItemFromCartUseCase =
            removeItemFromCartUseCase ?? RemoveItemFromCartUseCase(),
        _updateItemNotesUseCase = updateItemNotesUseCase ?? UpdateItemNotesUseCase(),
        _cartService = cartService ?? CartService(),
        super(CartInitial()) {
    on<LoadCartRequested>((event, emit) {
      emit(_buildLoaded());
    });

    on<AddCartItemRequested>((event, emit) {
      _addItemToCartUseCase.call(event.item, notes: event.notes);
      emit(_buildLoaded());
    });

    on<DecrementCartItemRequested>((event, emit) {
      _decrementItemInCartUseCase.call(event.item, notes: event.notes);
      emit(_buildLoaded());
    });

    on<RemoveCartItemRequested>((event, emit) {
      _removeItemFromCartUseCase.call(event.item, notes: event.notes);
      emit(_buildLoaded());
    });

    on<UpdateCartItemNotesRequested>((event, emit) {
      _updateItemNotesUseCase.call(
        event.item,
        event.newNotes,
        oldNotes: event.oldNotes,
      );
      emit(_buildLoaded());
    });

    on<ClearCartRequested>((event, emit) {
      _cartService.clear();
      emit(_buildLoaded());
    });
  }

  CartLoaded _buildLoaded() {
    final items = _getCartItemsUseCase.call();
    final total = _getCartTotalUseCase.call();
    return CartLoaded(items: items, total: total);
  }
}