abstract class ChangePasswordEvent {}

class ConfirmResetPasswordEvent extends ChangePasswordEvent {
  final String newPassword;

  ConfirmResetPasswordEvent({required this.newPassword});
}