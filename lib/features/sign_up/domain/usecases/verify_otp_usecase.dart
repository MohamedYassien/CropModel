import 'package:cropmodel/features/sign_up/data/model/otp/otp_request.dart';
import 'package:cropmodel/features/sign_up/data/model/otp/otp_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_service.dart';
import 'package:easy_localization/easy_localization.dart';

class VerifyOtpUseCase {
  final SignUpService _signUpService = SignUpService();

  Future<OTPResponse?> call(OTPRequest otpRequest) async {
    return await _signUpService.verifyOtp(otpRequest);
  }
}
