import 'package:cropmodel/core/network/api_client.dart';
import 'menu_api.dart';
import '../model/menu_model.dart';

class MenuServices {
  final APIClient apiClient = APIClient();

  Future<List<MenuCategoryModel>> getRestaurantMenu(String restaurantId) async {
    final response = await apiClient.fetch<List<dynamic>, List<MenuCategoryModel>>(
      api: MenuApi.getMenu,
      pathParam: restaurantId,
      mapper: (data) => data
          .map((json) => MenuCategoryModel.fromJson(json as Map<String, dynamic>))
          .toList(),
    );

    return response ?? [];
  }
}