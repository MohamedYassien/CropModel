import 'package:cropmodel/features/sign_up/data/model/sign-up/sign_up_request.dart';

abstract class SignUpEvent{}

class SignUpButtonPressed extends SignUpEvent {

  final SignUpRequest signUpRequest;

  SignUpButtonPressed({required this.signUpRequest});
}