import 'package:cropmodel/core/shared/data.dart';
import 'package:cropmodel/features/Menu/data/model/menu_model.dart';
import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/Profile/data/model/user_model.dart';
import 'package:cropmodel/features/room/data/model/order.dart';
import 'package:cropmodel/features/room/data/model/room.dart';

class RoomService {
  final AppData _appData;

  RoomService({AppData? appData}) : _appData = appData ?? AppData.instance;

  static final UserModel guestUser = UserModel(
    name: 'Guest',
    email: 'guest@corpmeal.local',
    phoneNumber: '0000000000',
  );

  List<Room> getOpenRooms() {
    return _appData.myRooms.where((r) => r.status == RoomStatus.open).toList();
  }

  Room createRoom({required String name, required RestaurantModel restaurant}) {
    final room = Room(
      name: name,
      restaurantModel: restaurant,
      orders: <Order>[],
      users: [],
      ownerId: '',
      createdAt: DateTime.now().toIso8601String(),
      status: RoomStatus.open,
      visability: RoomVisability(isPublic: true, isPrivate: false),
    );

    _appData.myRooms.add(room);
    return room;
  }

  void addOrderToRoom({required Room room, required Order order}) {
    room.orders.add(order);
  }

  void addMenuItemToRoom({required Room room, required MenuItemModel item}) {
    final existingIndex = room.orders.indexWhere(
      (o) => o.user.email == guestUser.email,
    );

    if (existingIndex >= 0) {
      room.orders[existingIndex].items.add(item);
      return;
    }

    room.orders.add(Order(user: guestUser, items: [item]));
  }
}
