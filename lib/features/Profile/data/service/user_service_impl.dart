import '../../data/service/user_service.dart';
import '../model/user_model.dart';

class UserRepositoryImpl implements UserRepository {

  UserModel _mockUser = UserModel(
    name: "John Doe",
    email: "john.doe@example.com",
    phoneNumber: "+123456789",
    isFingerprintEnabled: false,
  );

  @override
  Future<UserModel> getProfile() async {
    await Future.delayed(const Duration(seconds: 1));
    return _mockUser;
  }

  @override
  Future<void> updateProfile(UserModel user) async {
    await Future.delayed(const Duration(seconds: 1));



    _mockUser = user;
    print("Data sent to 'Backend': ${user.name}");
  }
}