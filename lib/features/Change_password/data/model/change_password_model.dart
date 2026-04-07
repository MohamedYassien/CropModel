class ResetPasswordModel {
  final bool success;
  final String message;

  ResetPasswordModel({required this.success, required this.message});

  factory ResetPasswordModel.fromJson(Map<String, dynamic> json) {
    return ResetPasswordModel(
      success: json['success'] ?? false,
      message: json['message'] ?? 'unknown error',
    );
  }
}