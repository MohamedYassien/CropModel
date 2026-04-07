import '../../domain/repositories/change_password_repository.dart';
import '../service/change_password_service.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordService _remote;

  ChangePasswordRepositoryImpl(this._remote);

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    try {
      await _remote.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } catch (e) {
      throw Exception("Failed to change password");
    }
  }
}
