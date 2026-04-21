
import 'package:cropmodel/features/Profile/data/model/user_model.dart';
import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/room/data/model/order.dart';

enum RoomStatus {
  open,
  closed,
}

class RoomVisability {
  bool isPublic;
  bool isPrivate;
  
  RoomVisability({
    required this.isPublic,
    required this.isPrivate,
  });
}

class Room{
  String name;
  RestaurantModel restaurantModel;
  List<Order> orders;
  List<UserModel> users;
  String ownerId;
  String createdAt;
  RoomStatus status;
  RoomVisability visability;

  Room({
    required this.name,
    required this.restaurantModel,
    required this.orders,
    required this.users,
    required this.ownerId,
    required this.createdAt,
    required this.status,
    required this.visability,
  });
}