abstract class ChangePasswordEvent {}

class ChangePasswordSubmitted extends ChangePasswordEvent {
  final String email;
  final String currentPassword;
  final String newPassword;

  ChangePasswordSubmitted({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });
}
