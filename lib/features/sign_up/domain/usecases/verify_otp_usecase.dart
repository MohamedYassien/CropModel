import 'package:cropmodel/features/sign_up/data/model/otp/otp_request.dart';
import 'package:cropmodel/features/sign_up/data/model/otp/otp_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_service.dart';
import 'package:easy_localization/easy_localization.dart';

class VerifyOtpUseCase {
  final SignUpService _signUpService = SignUpService();

  Future<OTPResponse?> call(OTPRequest otpRequest) async {
    if (otpRequest.otp.isEmpty) {
      throw Exception("otp_cannot_be_empty".tr());
    }
    if (otpRequest.otp.length != 6) {
      throw Exception("otp_must_be_6_digits".tr());
    }

    return await _signUpService.verifyOtp(otpRequest);
  }
}
