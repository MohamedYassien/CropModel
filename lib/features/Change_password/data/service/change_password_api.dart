import 'package:cropmodel/core/network/API.dart';

enum ChangePasswordApi implements API {
  changePassword(Method.post, '/auth/change-password');

  @override
  final String path;

  @override
  final Method method;

  const ChangePasswordApi(this.method, this.path);
}
