
import '../model/user_model.dart';

abstract class UserRepository {
  Future<UserModel> getProfile();
  Future<void> updateProfile(UserModel user);
}