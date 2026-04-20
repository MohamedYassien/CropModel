class ChangePasswordRequestModel {
  final String email;
  final String currentPassword;
  final String newPassword;

  const ChangePasswordRequestModel({
    required this.email,
    required this.currentPassword,
    required this.newPassword,
  });

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'currentPassword': currentPassword,
      'newPassword': newPassword,
    };
  }
}

class ChangePasswordResponseModel {
  final bool success;
  final String message;

  const ChangePasswordResponseModel({
    required this.success,
    required this.message,
  });

  factory ChangePasswordResponseModel.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponseModel(
      success: json['success'] == true,
      message: (json['message'] ?? '').toString(),
    );
  }
}
