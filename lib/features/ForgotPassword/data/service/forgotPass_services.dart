import 'package:cropmodel/core/network/api_client.dart';
import 'forgotPass_api.dart';

class ForgotpassServices {
  final APIClient apiClient = APIClient();

  Future<void> sendOtp(String email) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: ForgotpassApi.sendOtp,
      body: {
        "email": email,
      },
      mapper: (_) {},
    );
  }

  Future<void> verifyOtp(String email, String otp) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: ForgotpassApi.verifyOtp,
      body: {
        "email": email,
        "otp": otp,
      },
      mapper: (_) {},
    );
  }

  Future<void> resendOTP(String email) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: ForgotpassApi.resendOTP,
      body: {
        "email": email,
      },
      mapper: (_) {},
    );
  }

  Future<void> resetPassword(String email, String otp, String password) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: ForgotpassApi.resetPassword,
      body: {
        "email": email,
        "otp": otp,
        "newPassword": password,
      },
      mapper: (_) {},
    );
  }
}