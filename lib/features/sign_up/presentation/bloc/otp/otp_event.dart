abstract class OTPEvent{}

class OTPButtonPressed extends OTPEvent {

  final String email;
  final String otp;

  OTPButtonPressed({required this.email, required this.otp});
}

class OTPResendButtonPressed extends OTPEvent {

  final String email;

  OTPResendButtonPressed({required this.email});
}
