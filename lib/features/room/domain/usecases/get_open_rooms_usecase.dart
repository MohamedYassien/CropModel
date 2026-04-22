import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/room/data/service/room_service.dart';

class GetOpenRoomsUseCase {
  final RoomService _roomService;

  GetOpenRoomsUseCase({RoomService? roomService})
      : _roomService = roomService ?? RoomService();

  List<Room> call() {
    return _roomService.getOpenRooms();
  }
}
