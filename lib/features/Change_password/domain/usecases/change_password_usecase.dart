import '../../data/model/reset_password_model.dart';
import '../../data/service/reset_password_service.dart';

class ConfirmResetPasswordUseCase {
  final ResetPasswordService _service = ResetPasswordService();

  Future<ResetPasswordModel?> call(String newPassword) {
    return _service.confirmResetPassword(newPassword);
  }
}