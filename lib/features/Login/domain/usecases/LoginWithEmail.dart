import '../../data/service/LoginService.dart';

class LoginWithEmail {
  final LoginService _loginService;

  LoginWithEmail(this._loginService);

  Future<void> call(String email, String password) async {
    return await _loginService.login(email, password);
  }
}