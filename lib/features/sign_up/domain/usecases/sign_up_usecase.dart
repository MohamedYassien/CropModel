import 'package:cropmodel/features/sign_up/data/model/sign-up/sign_up_request.dart';
import 'package:cropmodel/features/sign_up/data/model/sign-up/sign_up_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_service.dart';

class SignUpUseCase {

  final SignUpService _signUpService = SignUpService();

  Future<SignUpResponse?> call(SignUpRequest signUpRequest) async {
    return await _signUpService.signUp(signUpRequest);
  }
}