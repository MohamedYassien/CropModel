import 'package:cropmodel/core/network/API.dart';

enum ForgotpassApi implements API{
  resetPassword(Method.post, 'reset-password'),
  sendOtp(Method.post, 'send-otp'),
  verifyOtp(Method.post, 'verify-otp');

  final String path;
  final Method method;
  const ForgotpassApi(this.method,this.path);
}