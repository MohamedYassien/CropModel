import 'package:cropmodel/core/network/API.dart';

enum SignUpApi implements API {
  signUp(Method.post, 'sign-up'),
  verifyOtp(Method.post, 'verify-otp'),
  resendOTP(Method.post, 'resend-otp');

  @override
  final String path;

  @override
  final Method method;

  const SignUpApi(this.method,this.path);
}