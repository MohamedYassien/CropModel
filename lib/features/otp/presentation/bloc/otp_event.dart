abstract class OtpEvent {}

class SubmitOtpEvent extends OtpEvent {
  final String otp;
  SubmitOtpEvent(this.otp);
}

class ResendOtpEvent extends OtpEvent {
  final String phone;
  ResendOtpEvent(this.phone);
}
