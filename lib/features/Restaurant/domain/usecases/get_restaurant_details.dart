import '../../data/model/restaurant_model.dart';
import '../../data/service/restaurant_services.dart';

class GetRestaurantDetailsUseCase {
  RestaurantService restaurantService = RestaurantService();

  Future<RestaurantModel> call(String restaurantId) async {
    return await restaurantService.getRestaurantById(restaurantId);
  }
}