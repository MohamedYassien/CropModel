abstract class CreatePasswordEvent {}

class CreatePasswordButtonPressed extends CreatePasswordEvent {
  final String password;
  final String email;
  final String otp;

  CreatePasswordButtonPressed({ required this.email, required this.otp, required this.password});
}