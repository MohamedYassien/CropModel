import '../../domain/repositories/change_password_repository.dart';
import '../model/change_password_model.dart';
import '../service/change_password_service.dart';

class ChangePasswordRepositoryImpl implements ChangePasswordRepository {
  final ChangePasswordService _remote;

  ChangePasswordRepositoryImpl(this._remote);

  @override
  Future<ChangePasswordResponseModel> changePassword({
    required String email,
    required String currentPassword,
    required String newPassword,
  }) async {
    return _remote.changePassword(
      request: ChangePasswordRequestModel(
        email: email,
        currentPassword: currentPassword,
        newPassword: newPassword,
      ),
    );
  }
}
