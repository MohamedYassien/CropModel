import 'package:cropmodel/features/room/data/model/room.dart';
import 'package:cropmodel/features/Profile/data/model/user_model.dart';

class AppData {
  static final AppData instance = AppData._();

  AppData._();

  List<Room> myRooms = [];

  UserModel? currentUser;

  void clearSession() {
    currentUser = null;
    myRooms = [];
  }
}
