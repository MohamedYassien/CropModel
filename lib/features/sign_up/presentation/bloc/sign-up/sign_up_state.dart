abstract class SignUpState {}

class SignUpInitial extends SignUpState {}

class SignUpLoading extends SignUpState {}

class SignUpSuccess extends SignUpState {}

class SignUpError extends SignUpState {
  final String message;

  SignUpError(this.message);
}

class OTPResendLoading extends SignUpState {}

class OTPResendSuccess extends SignUpState {}

class OTPResendError extends SignUpState {
  final String message;

  OTPResendError(this.message);
}


