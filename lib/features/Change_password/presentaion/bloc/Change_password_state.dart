abstract class ChangePasswordState {}

class ResetPasswordInitial extends ChangePasswordState {}

class ResetPasswordLoading extends ChangePasswordState {}

class ResetPasswordSuccess extends ChangePasswordState {}

class ResetPasswordError extends ChangePasswordState {
  final String message;

  ResetPasswordError({required this.message});
}