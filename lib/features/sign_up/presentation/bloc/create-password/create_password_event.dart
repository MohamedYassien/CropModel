abstract class CreatePasswordEvent {}

class CreatePasswordButtonPressed extends CreatePasswordEvent {
  final String password;

  CreatePasswordButtonPressed({required this.password});
}