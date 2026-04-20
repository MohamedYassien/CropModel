import '../../data/service/forgotpass_services.dart';

class ResendOtpUsecase {
  ForgotpassServices services = ForgotpassServices();

  Future<void> call(String email) {
    return services.resendOTP(email);
  }
}