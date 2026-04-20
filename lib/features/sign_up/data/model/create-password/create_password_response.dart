class CreatePasswordResponse{
  final bool success;
  final String message;
  CreatePasswordResponse({
    required this.success,
    required this.message,
  });

  factory CreatePasswordResponse.fromJson(Map<String, dynamic> json) {
    return CreatePasswordResponse(
      success: json['success'] ?? '',
      message: json['message'] ?? '',
    );
  }
}