import '../../data/service/forgotpass_services.dart';

class VerifyOtpUseCase {
  final ForgotpassServices services;

  VerifyOtpUseCase(this.services);

  Future<void> call(String email, String otp) {
    return services.verifyOtp(email, otp);
  }
}