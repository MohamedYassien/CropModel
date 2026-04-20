import '../repositories/change_password_repository.dart';
import '../../data/model/change_password_model.dart';

class ChangePasswordUseCase {
  final ChangePasswordRepository repository;

  ChangePasswordUseCase(this.repository);

  Future<ChangePasswordResponseModel> call({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) {
    return repository.changePassword(
      email: email,
      currentPassword: currentPassword,
      newPassword: newPassword,
    );
  }
}
