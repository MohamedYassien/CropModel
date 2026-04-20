import 'package:cropmodel/core/network/api_client.dart';
import '../model/change_password_model.dart';
import 'change_password_api.dart';

class ChangePasswordService {
  final APIClient apiClient;

  ChangePasswordService(this.apiClient);
  Future<ChangePasswordResponseModel> changePassword({
    required ChangePasswordRequestModel request,
  }) async {
    final response = await apiClient
        .fetch<Map<String, dynamic>, ChangePasswordResponseModel>(
          api: ChangePasswordApi.changePassword,
          body: request.toJson(),
          mapper: (json) => ChangePasswordResponseModel.fromJson(
            json as Map<String, dynamic>,
          ),
        );
    return response ??
        const ChangePasswordResponseModel(
          success: false,
          message: 'Something went wrong',
        );
  }
}
