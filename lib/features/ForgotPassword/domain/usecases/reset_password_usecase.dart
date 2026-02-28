import '../../data/service/forgotpass_services.dart';

class ResetPasswordUseCase {
  final ForgotpassServices services;

  ResetPasswordUseCase(this.services);

  Future<void> call(String email, String password) {
    return services.resetPassword(email, password);
  }
}