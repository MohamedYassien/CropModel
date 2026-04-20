abstract class ForgotPassState {}

class ForgotPassInitial extends ForgotPassState {}

class ForgotPassLoading extends ForgotPassState {}

class OTPInitial extends ForgotPassState {}

class OTPVerifyLoading extends ForgotPassState {}

class OTPVerifySuccess extends ForgotPassState {}

class OTPVerifyError extends ForgotPassState {
  final String message;

  OTPVerifyError(this.message);
}

class OtpSentState extends ForgotPassState {}

class OtpVerifiedState extends ForgotPassState {}


class OTPResendLoading extends ForgotPassState {}

class OTPResendSuccess extends ForgotPassState {}

class OTPResendError extends ForgotPassState {
  final String message;

  OTPResendError(this.message);
}

class PasswordResetState extends ForgotPassState {}

class PasswordResetLoading extends ForgotPassState {}

class ForgotPassError extends ForgotPassState {
  final String message;

  ForgotPassError(this.message);
}
class ForgotPassPasswordReset extends ForgotPassState {}