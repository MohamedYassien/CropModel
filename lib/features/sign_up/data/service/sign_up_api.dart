import 'package:cropmodel/core/network/API.dart';

enum SignUpApi implements API {
  signUp(Method.post, 'sign-up');

  @override
  final String path;

  @override
  final Method method;

  const SignUpApi(this.method,this.path);
}