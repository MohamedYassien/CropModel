abstract class ResetPasswordEvent {}

class ConfirmResetPasswordEvent extends ResetPasswordEvent {
  final String newPassword;

  ConfirmResetPasswordEvent({required this.newPassword});
}