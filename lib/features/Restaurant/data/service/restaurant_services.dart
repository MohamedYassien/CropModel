import 'package:cropmodel/core/network/api_client.dart';
import 'restaurant_api.dart';
import '../model/restaurant_model.dart';

class RestaurantServices {
  final APIClient apiClient = APIClient();

  Future<List<RestaurantModel>> getRestaurants() async {
    final response = await apiClient.fetch<List<dynamic>, List<RestaurantModel>>(
      api: RestaurantApi.getRestaurants,
      mapper: (data) => data
          .map((json) => RestaurantModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );
    return response ?? [];
  }
}