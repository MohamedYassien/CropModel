abstract class ForgotPassState {}

class ForgotPassInitial extends ForgotPassState {}

class ForgotPassLoading extends ForgotPassState {}

class OtpSentState extends ForgotPassState {}

class OtpVerifiedState extends ForgotPassState {}

class PasswordResetState extends ForgotPassState {}

class ForgotPassError extends ForgotPassState {
  final String message;

  ForgotPassError(this.message);
}
class ForgotPassPasswordReset extends ForgotPassState {}