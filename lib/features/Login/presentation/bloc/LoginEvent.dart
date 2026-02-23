abstract class LoginEvent {}

class LoginWithEmailEvent extends LoginEvent {
  final String email;
  final String password;

  LoginWithEmailEvent(this.email, this.password);
}

class BiometricLoginEvent extends LoginEvent {}

class LogoutEvent extends LoginEvent {}
