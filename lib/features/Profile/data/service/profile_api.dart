import 'package:cropmodel/core/network/API.dart';

enum UserApi implements API {
  getProfile(Method.get, 'https://jsonplaceholder.typicode.com/users/1'),
  updateProfile(Method.put, 'https://jsonplaceholder.typicode.com/users/1');

  @override
  final String path;

  @override
  final Method method;

  const UserApi(this.method, this.path);
}