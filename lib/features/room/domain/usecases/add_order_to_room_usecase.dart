import 'package:cropmodel/features/room/data/model/order.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/room/data/service/room_service.dart';

class AddOrderToRoomUseCase {
  final RoomService _roomService;

  AddOrderToRoomUseCase({RoomService? roomService})
      : _roomService = roomService ?? RoomService();

  void call({
    required Room room,
    required Order order,
  }) {
    _roomService.addOrderToRoom(room: room, order: order);
  }
}
