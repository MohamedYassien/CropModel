import 'package:cropmodel/features/sign_up/data/model/sign_up_request.dart';

abstract class SignUpEvent{}

class SignUpButtonPressed extends SignUpEvent {

  final SignUpRequest signUpRequest;

  SignUpButtonPressed({required this.signUpRequest});
}