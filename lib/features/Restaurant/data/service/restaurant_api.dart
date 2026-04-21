import 'package:cropmodel/core/network/API.dart';

enum RestaurantApi implements API {
  getRestaurants(Method.get, 'restaurants');

  final String path;
  final Method method;
  const RestaurantApi(this.method, this.path);
}