abstract class OTPState{}

class OTPInitial extends OTPState {}

class OTPVerifyLoading extends OTPState {}

class OTPVerifySuccess extends OTPState {}

class OTPVerifyError extends OTPState {
  final String message;

  OTPVerifyError(this.message);
}

class OTPResendLoading extends OTPState {}

class OTPResendSuccess extends OTPState {}

class OTPResendError extends OTPState {
  final String message;

  OTPResendError(this.message);
}
