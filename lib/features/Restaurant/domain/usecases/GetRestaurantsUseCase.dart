import '../../data/model/restaurant_model.dart';
import '../../data/service/restaurant_services.dart';

class GetRestaurantsUseCase {
  final RestaurantServices repository;

  GetRestaurantsUseCase(this.repository);

  Future<List<RestaurantModel>> call() async {
    return await repository.getRestaurants();
  }
}