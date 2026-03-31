import '../../data/model/user_model.dart';
import '../../data/service/profile_service.dart';

class GetProfileUseCase {
  final UserService _userService = UserService();

  GetProfileUseCase();

  Future<UserModel?> call() async {
    return await _userService.fetchProfile();
  }
}