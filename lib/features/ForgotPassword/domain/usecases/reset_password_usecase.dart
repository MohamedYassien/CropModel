
import '../../data/service/forgotPass_services.dart';

class ResetPasswordUseCase {
   ForgotpassServices services = ForgotpassServices();


  Future<void> call(String email, String otp, String password) {
    return services.resetPassword(email, otp, password);
  }
}