import 'package:cropmodel/features/Menu/data/model/menu_model.dart';
import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/room/data/service/room_service.dart';

class AddMenuItemToRoomUseCase {
  final RoomService _roomService;

  AddMenuItemToRoomUseCase({RoomService? roomService})
      : _roomService = roomService ?? RoomService();

  void call({
    required Room room,
    required MenuItemModel item,
  }) {
    _roomService.addMenuItemToRoom(room: room, item: item);
  }
}
