import '../../../Menu/data/model/menu_model.dart';
import '../../../Restaurant/data/service/restaurant_services.dart';

class GetMenuUseCase {
  RestaurantService restaurantService = RestaurantService();

  Future<List<MenuCategoryModel>> call(String restaurantId) async {
    final restaurant = await restaurantService.getRestaurantById(restaurantId);
    return restaurant.menuCategories;
  }
}