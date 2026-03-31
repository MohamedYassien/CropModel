import '../../data/model/user_model.dart';
import '../../data/service/profile_service.dart';

class UpdateProfileUseCase {
  final UserService _userService = UserService();

  UpdateProfileUseCase();

  Future<void> call(UserModel user) async {
    return await _userService.updateProfile(user);
  }
}