import 'package:cropmodel/features/Profile/data/service/profile_api.dart';

import '../../../../core/network/api_client.dart';
import '../model/user_model.dart';

class UserService {
  final APIClient apiClient = APIClient();

  Future<UserModel?> fetchProfile() async {
    return await apiClient.fetch<void, UserModel?>(
      api: UserApi.getProfile,
      mapper: (json) => UserModel.fromJson(json),
    );
  }

  Future<void> updateProfile(UserModel user) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: UserApi.updateProfile,
      body: user.toJson(),
      mapper: (json) => null,
    );
  }
}