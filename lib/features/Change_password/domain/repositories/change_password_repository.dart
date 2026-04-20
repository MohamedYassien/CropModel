import '../../data/model/change_password_model.dart';

abstract class ChangePasswordRepository {
  Future<ChangePasswordResponseModel> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  });
}
