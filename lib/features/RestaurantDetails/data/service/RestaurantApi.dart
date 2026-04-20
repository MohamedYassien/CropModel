import 'package:cropmodel/core/network/API.dart';

enum RestaurantApi implements API {
  getRestaurantDetails(Method.get, 'restaurants/{id}'),
  getRestaurantsList(Method.get, 'restaurants');

  final String path;
  final Method method;

  const RestaurantApi(this.method, this.path);
}