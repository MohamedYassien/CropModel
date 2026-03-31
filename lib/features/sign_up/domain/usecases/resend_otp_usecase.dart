import 'package:cropmodel/features/sign_up/data/model/otp/otp_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_service.dart';

class ResendOtpUseCase {

  SignUpService signUpService = SignUpService();

  Future<OTPResponse?> call(String email) async {
   return signUpService.resendOTP(email);
  }
}