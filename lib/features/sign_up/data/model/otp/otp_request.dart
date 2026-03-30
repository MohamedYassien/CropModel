class OTPRequest {

  final String otp;

  final String email;

  OTPRequest({required this.otp, required this.email});

  Map<String, dynamic> toJson() {
    return {
      'otp': otp,
      'email': email
    };
  }
}