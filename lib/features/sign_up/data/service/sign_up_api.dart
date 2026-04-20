import 'package:cropmodel/core/network/API.dart';

enum SignUpApi implements API {
  signUp(Method.post, '/auth/signup/create-user'),
  verifyOtp(Method.post, '/auth/verify-otp'),
  resendOTP(Method.post, '/auth/forgot-password/send-otp'),
  createPassword(Method.post, '/auth/signup/create-password');

  @override
  final String path;
  @override
  final Method method;

  const SignUpApi(this.method, this.path);
}

