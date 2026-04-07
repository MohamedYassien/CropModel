import 'package:cropmodel/features/sign_up/data/model/create-password/create_password_request.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_service.dart';

class CreatePasswordUseCase {
  SignUpService signUpService = SignUpService();

  Future<void> call(String password) async {

      signUpService.createPassword(CreatePasswordRequest(password: password));
  }
}
