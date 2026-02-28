abstract class ForgotPassEvent {}

class SendOtpEvent extends ForgotPassEvent {
  final String email;

  SendOtpEvent(this.email);
}

class VerifyOtpEvent extends ForgotPassEvent {
  final String email;
  final String otp;

  VerifyOtpEvent(this.email, this.otp);
}

class ResetPasswordEvent extends ForgotPassEvent {
  final String email;
  final String password;

  ResetPasswordEvent(this.email, this.password);
}