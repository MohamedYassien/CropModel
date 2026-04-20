abstract class ForgotPassEvent {}

class SendOtpEvent extends ForgotPassEvent {
  final String email;

  SendOtpEvent(this.email);
}

class VerifyOtpEvent extends ForgotPassEvent {
  final String email;
  final String otp;

  VerifyOtpEvent({required this.email, required this.otp});
}

class ResetPasswordEvent extends ForgotPassEvent {
  final String email;
  final String otp;
  final String password;

  ResetPasswordEvent(this.email, this.otp, this.password);
}

class OTPButtonPressed extends ForgotPassEvent {

  final String email;
  final String otp;

  OTPButtonPressed({required this.email, required this.otp});
}

class OTPResendButtonPressed extends ForgotPassEvent {

  final String email;

  OTPResendButtonPressed({required this.email});
}
