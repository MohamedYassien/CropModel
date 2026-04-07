abstract class CreatePasswordState {}

class CreatePasswordInitial extends CreatePasswordState {}

class CreatePasswordLoading extends CreatePasswordState {}

class CreatePasswordSuccess extends CreatePasswordState {}

class CreatePasswordError extends CreatePasswordState {
  final String message;

  CreatePasswordError(this.message);
}