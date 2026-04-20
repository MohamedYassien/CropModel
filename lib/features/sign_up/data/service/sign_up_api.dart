import 'package:cropmodel/core/network/API.dart';

enum SignUpApi implements API {
  signUp(Method.post, '/auth/signup/create-user'),
  verifyOtp(Method.post, 'verify-otp'),
  resendOTP(Method.post, 'resend-otp'),
  createPassword(Method.post, '/auth/signup/create-password');

  @override
  final String path;
  @override
  final Method method;

  const SignUpApi(this.method, this.path);
}

