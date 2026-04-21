import 'package:cropmodel/features/room/domain/usecases/add_order_to_room_usecase.dart';
import 'package:cropmodel/features/room/domain/usecases/create_room_usecase.dart';
import 'package:cropmodel/features/room/domain/usecases/get_open_rooms_usecase.dart';
import 'package:cropmodel/features/room/domain/usecases/get_restaurants_for_room_usecase.dart';
import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'room_event.dart';
import 'room_state.dart';

class RoomBloc extends Bloc<RoomEvent, RoomState> {
  final GetRestaurantsForRoomUseCase _getRestaurants;
  final GetOpenRoomsUseCase _getOpenRooms;
  final CreateRoomUseCase _createRoom;
  final AddOrderToRoomUseCase _addOrder;

  RoomBloc({
    GetRestaurantsForRoomUseCase? getRestaurants,
    GetOpenRoomsUseCase? getOpenRooms,
    CreateRoomUseCase? createRoom,
    AddOrderToRoomUseCase? addOrder,
  }) : _getRestaurants = getRestaurants ?? GetRestaurantsForRoomUseCase(),
       _getOpenRooms = getOpenRooms ?? GetOpenRoomsUseCase(),
       _createRoom = createRoom ?? CreateRoomUseCase(),
       _addOrder = addOrder ?? AddOrderToRoomUseCase(),
       super(RoomState.initial()) {
    on<RoomStarted>(_onStarted);
    on<RestaurantSelected>(_onRestaurantSelected);
    on<CreateRoomRequested>(_onCreateRoomRequested);
    on<AddOrderRequested>(_onAddOrderRequested);
  }

  /// Synchronous helper used by UI to create a room then navigate.
  /// Keeps the state in sync by refreshing `openRooms`.
  /// (Rooms are stored in-memory.)
  Room createRoomSync({
    required String roomName,
    required RestaurantModel restaurant,
  }) {
    final created = _createRoom.call(name: roomName, restaurant: restaurant);
    add(RoomStarted());
    return created;
  }

  Future<void> _onStarted(RoomStarted event, Emitter<RoomState> emit) async {
    emit(state.copyWith(loadingRestaurants: true, errorMessage: null));
    try {
      final restaurants = await _getRestaurants.call();
      final rooms = _getOpenRooms.call();
      emit(
        state.copyWith(
          loadingRestaurants: false,
          restaurants: restaurants,
          openRooms: rooms,
          selectedRestaurant: restaurants.isNotEmpty ? restaurants.first : null,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(loadingRestaurants: false, errorMessage: e.toString()),
      );
    }
  }

  void _onRestaurantSelected(
    RestaurantSelected event,
    Emitter<RoomState> emit,
  ) {
    emit(state.copyWith(selectedRestaurant: event.restaurant));
  }

  void _onCreateRoomRequested(
    CreateRoomRequested event,
    Emitter<RoomState> emit,
  ) {
    final restaurant = state.selectedRestaurant;
    if (restaurant == null) {
      emit(state.copyWith(errorMessage: 'Please select a restaurant first'));
      return;
    }

    _createRoom.call(name: event.roomName, restaurant: restaurant);
    emit(state.copyWith(openRooms: _getOpenRooms.call(), errorMessage: null));
  }

  void _onAddOrderRequested(AddOrderRequested event, Emitter<RoomState> emit) {
    _addOrder.call(room: event.room, order: event.order);
    emit(state.copyWith(openRooms: _getOpenRooms.call(), errorMessage: null));
  }
}
