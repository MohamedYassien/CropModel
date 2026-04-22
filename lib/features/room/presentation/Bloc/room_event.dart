import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/room/data/model/order.dart';
import 'package:cropmodel/features/room/data/model/room.dart';

abstract class RoomEvent {}

class RoomStarted extends RoomEvent {}

class RestaurantSelected extends RoomEvent {
  final RestaurantModel restaurant;

  RestaurantSelected(this.restaurant);
}

class CreateRoomRequested extends RoomEvent {
  final String roomName;

  CreateRoomRequested(this.roomName);
}

class CreateRoomAndNavigateRequested extends RoomEvent {
  final String roomName;
  final RestaurantModel restaurant;

  CreateRoomAndNavigateRequested({
    required this.roomName,
    required this.restaurant,
  });
}

class AddOrderRequested extends RoomEvent {
  final Room room;
  final Order order;

  AddOrderRequested({required this.room, required this.order});
}
