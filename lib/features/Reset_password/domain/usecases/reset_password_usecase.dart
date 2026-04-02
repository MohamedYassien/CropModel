import '../../data/model/reset_password_model.dart';
import '../../data/service/reset_password_service.dart';

class ConfirmResetPasswordUseCase {
  final ResetPasswordService _service = ResetPasswordService();

  // ضفنا علامة الاستفهام هنا عشان تتطابق مع السيرفيس
  Future<ResetPasswordModel?> call(String newPassword) {
    // تقدر تضيف أي Business Logic هنا مستقبلاً قبل ما تكلم الـ Service
    return _service.confirmResetPassword(newPassword);
  }
}