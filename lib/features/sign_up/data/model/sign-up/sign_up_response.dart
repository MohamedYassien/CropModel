class SignUpResponse {
  final bool success;
  final String message;
  SignUpResponse({
    required this.success,
    required this.message,
  });

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      success: json['success'] ?? '',
      message: json['message'] ?? '',
    );
  }
}