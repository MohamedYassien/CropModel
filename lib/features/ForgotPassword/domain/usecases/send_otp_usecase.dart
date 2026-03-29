import '../../data/service/forgotpass_services.dart';

class SendOtpUseCase {
  final ForgotpassServices services;

  SendOtpUseCase(this.services);

  Future<void> call(String email) {
    return services.sendOtp(email);
  }
}