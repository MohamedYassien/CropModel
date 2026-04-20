import 'package:cropmodel/features/sign_up/data/model/sign-up/sign_up_request.dart';

abstract class SignUpEvent{}

class SignUpButtonPressed extends SignUpEvent {

  final SignUpRequest signUpRequest;

  SignUpButtonPressed({required this.signUpRequest});
}

class VerifyOtpSubmitted extends SignUpEvent {
  final String email;
  final String otp;

  VerifyOtpSubmitted({required this.email, required this.otp});
}

class OTPResendButtonPressed extends SignUpEvent {

  final String email;

  OTPResendButtonPressed({required this.email});
}