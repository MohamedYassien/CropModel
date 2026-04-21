import '../../data/model/menu_model.dart';
import '../../data/service/menu_services.dart';

class GetMenuUseCase {
  final MenuServices repository;

  GetMenuUseCase(this.repository);

  Future<List<MenuCategoryModel>> call(String restaurantId) async {
    return await repository.getRestaurantMenu(restaurantId);
  }
}