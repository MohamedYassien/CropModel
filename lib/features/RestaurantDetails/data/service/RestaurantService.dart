import 'package:cropmodel/core/network/api_client.dart';
import '../model/restaurantmodel.dart';

class RestaurantServices {
  final APIClient apiClient = APIClient();

  // Fetch single restaurant with location data for Google Map
  // Future<RestaurantModel?> getRestaurantDetails(String id) async {
  //   return await apiClient.fetch<void, RestaurantModel?>(
  //     api: RestaurantApi.getRestaurantDetails,
  //     pathParams: {'id': id},
  //     mapper: (response) {
  //       final data = response['data'] ?? response;
  //       return RestaurantModel.fromJson(data);
  //     },
  //   );
  // }

  // Fetch list for restaurant selection screen
  // Future<List<RestaurantModel>?> getRestaurantsList() async {
  //   return await apiClient.fetch<void, List<RestaurantModel>?>(
  //     api: RestaurantApi.getRestaurantsList,
  //     mapper: (response) {
  //       final List data = response['results'] ?? response['data'] ?? [];
  //       return data.map((json) => RestaurantModel.fromJson(json)).toList();
  //     },
  //   );
  // }
}