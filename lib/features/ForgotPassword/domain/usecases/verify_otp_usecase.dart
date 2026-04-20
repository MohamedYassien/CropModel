import '../../data/service/forgotpass_services.dart';

class VerifyOtpUseCase {
  ForgotpassServices services = ForgotpassServices();


  Future<void> call(String email, String otp) {
    return services.verifyOtp(email, otp);
  }
}