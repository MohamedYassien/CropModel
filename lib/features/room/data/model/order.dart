import 'package:cropmodel/features/Menu/data/model/menu_model.dart';
import 'package:cropmodel/features/Profile/data/model/user_model.dart';

class Order {
  UserModel user;
  List<MenuItemModel> items;

  Order({
    required this.user,
    required this.items,
  });
}