import 'package:cropmodel/features/sign_up/data/model/create-password/create_password_request.dart';
import 'package:cropmodel/features/sign_up/data/model/otp/otp_request.dart';
import 'package:cropmodel/features/sign_up/data/model/otp/otp_response.dart';
import 'package:cropmodel/features/sign_up/data/model/sign-up/sign_up_request.dart';
import 'package:cropmodel/features/sign_up/data/model/sign-up/sign_up_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_api.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/api_client.dart';

class SignUpService {
  final APIClient apiClient = APIClient();

  Future<SignUpResponse?> signUp(SignUpRequest signUpRequest) async {
    return await apiClient.fetch<FormData, SignUpResponse?>(
      api: SignUpApi.signUp,
      body: signUpRequest.toFormData(),
      mapper: (response) {
        return SignUpResponse.fromJson(response);
      },
    );
  }

  Future<OTPResponse?> verifyOtp(OTPRequest otpRequest) async {
    return await apiClient.fetch<OTPRequest, OTPResponse?>(
      api: SignUpApi.verifyOtp,
      body: otpRequest,
      mapper: (response) {
        return null;
      },
    );
  }

  Future<OTPResponse?> resendOTP(String email) async {
    return await apiClient.fetch<String, OTPResponse?>(
      api: SignUpApi.resendOTP,
      body: email,
      mapper: (response) {
        return null;
      },
    );
  }

  Future<SignUpResponse?> createPassword(
    CreatePasswordRequest createPasswordRequest,
  ) async {
    return await apiClient
        .fetch<Map<String,String>, SignUpResponse?>(
          api: SignUpApi.createPassword,
          body: createPasswordRequest.toJson(),
          mapper: (response) {
            return SignUpResponse.fromJson(response);
          },
        );
  }
}
