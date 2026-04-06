import 'package:cropmodel/core/network/API.dart';

enum ResetPasswordApi implements API {
  confirmResetPassword(Method.post, 'auth/reset-password');

  @override
  final String path;

  @override
  final Method method;

  const ResetPasswordApi(this.method, this.path);
}