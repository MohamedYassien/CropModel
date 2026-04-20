class CreatePasswordRequest {

  final String email;
  final String otp;
  final String password;

  CreatePasswordRequest({
    required this.email,
    required this.otp,
    required this.password,
  });

  Map<String, String> toJson() {
    return {
      'email': email,
      "otp": otp,
      'password': password,
    };
  }
}