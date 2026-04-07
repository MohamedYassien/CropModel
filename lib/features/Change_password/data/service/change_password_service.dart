import 'package:cropmodel/core/network/api_client.dart';
import 'change_password_api.dart';

class ChangePasswordService {
  final APIClient apiClient;

  ChangePasswordService(this.apiClient);
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: ChangePasswordApi.changePassword,
      body: {
        "current_password": currentPassword,
        "new_password": newPassword,
      },
      mapper: (_) {},
    );
  }
}