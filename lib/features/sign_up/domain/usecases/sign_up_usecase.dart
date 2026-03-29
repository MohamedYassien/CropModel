import 'package:cropmodel/features/sign_up/data/model/sign_up_request.dart';
import 'package:cropmodel/features/sign_up/data/model/sign_up_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_service.dart';

class SignUpUseCase {

  final SignUpService _signUpService = SignUpService();

  SignUpUseCase();

  Future<SignUpResponse?> call(SignUpRequest signUpRequest) async {
    return await _signUpService.signUp(signUpRequest);
  }
}