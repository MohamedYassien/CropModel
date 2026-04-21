import 'package:cropmodel/core/network/API.dart';

enum UserApi implements API {
  getProfile(Method.get, '/users/get-profile'),
  updateProfile(Method.put, '/users/update-profile');

  @override
  final String path;

  @override
  final Method method;

  const UserApi(this.method, this.path);
}