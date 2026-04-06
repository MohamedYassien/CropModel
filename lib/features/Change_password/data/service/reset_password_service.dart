import 'package:cropmodel/core/network/api_client.dart';
import 'reset_password_api.dart';
import '../model/reset_password_model.dart';

class ResetPasswordService {
  final APIClient apiClient = APIClient();

  Future<ResetPasswordModel?> confirmResetPassword(String newPassword) async {
    return await apiClient.fetch<Map<String, dynamic>, ResetPasswordModel>(
      api: ResetPasswordApi.confirmResetPassword,
      body: {
        "new_password": newPassword,
      },
      mapper: (response) {
        return ResetPasswordModel.fromJson(response);
      },
    );
  }
}