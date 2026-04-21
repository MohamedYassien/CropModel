import 'package:cropmodel/features/Restaurant/data/model/restaurant_model.dart';
import 'package:cropmodel/features/Restaurant/data/service/restaurant_services.dart';

class GetRestaurantsForRoomUseCase {
  final RestaurantService _restaurantService;

  GetRestaurantsForRoomUseCase({RestaurantService? restaurantService})
      : _restaurantService = restaurantService ?? RestaurantService();

  Future<List<RestaurantModel>> call() {
    return _restaurantService.getRestaurants();
  }
}
