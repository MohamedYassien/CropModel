import 'package:dio/dio.dart';

class SignUpRequest {
  final String fullName;
  final String email;
  final String phone;

  SignUpRequest({
    required this.fullName,
    required this.email,
    required this.phone,
  });

  FormData toFormData() {
    return FormData.fromMap({
      'fullName': fullName,
      'email': email,
      'phone': phone,
    });
  }
}