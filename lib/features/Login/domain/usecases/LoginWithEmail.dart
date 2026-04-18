import 'package:cropmodel/features/Login/data/model/LoginRequest.dart';
import 'package:cropmodel/features/Login/data/model/LoginResponse.dart';

import '../../data/service/LoginService.dart';

class LoginWithEmail {
  final LoginService _loginService;

  LoginWithEmail(this._loginService);

  Future<LoginResponse?> call(LoginRequest request) async {
    return await _loginService.login(request);
  }
}