import 'package:cropmodel/core/network/API.dart';

enum LoginApi implements API {
  login(Method.post, 'login');

  final String path;
  final Method method;
  const LoginApi(this.method, this.path);
}