import 'package:cropmodel/core/network/API.dart';

enum ForgotpassApi implements API{
  sendOtp(Method.post, 'auth/forgot-password/send-otp'),
  verifyOtp(Method.post, 'auth/verify-otp'),
  resendOTP(Method.post, 'auth/forgot-password/send-otp'),
  resetPassword(Method.post, 'auth/forgot-password/reset-password');

  final String path;
  final Method method;
  const ForgotpassApi(this.method,this.path);
}