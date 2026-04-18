import 'package:cropmodel/core/network/API.dart';

enum SignUpApi implements API {
  signUp(Method.post, 'auth/sign-up'),
  verifyOtp(Method.post, 'auth/verify-otp'),
  resendOTP(Method.post, 'auth/resend-otp'),
  createPassword(Method.post, 'auth/create-password');

  @override
  final String path;
  @override
  final Method method;

  const SignUpApi(this.method, this.path);
}

