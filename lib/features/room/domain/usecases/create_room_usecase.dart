import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/room/data/service/room_service.dart';

class CreateRoomUseCase {
  final RoomService _roomService;

  CreateRoomUseCase({RoomService? roomService})
      : _roomService = roomService ?? RoomService();

  Room call({
    required String name,
    required RestaurantModel restaurant,
  }) {
    return _roomService.createRoom(name: name, restaurant: restaurant);
  }
}
