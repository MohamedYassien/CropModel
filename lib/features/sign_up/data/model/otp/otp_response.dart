class OTPResponse {
  final bool? success;
  final String? message;

  OTPResponse({this.success, this.message});

  factory OTPResponse.fromJson(Map<String, dynamic> json) {
    return OTPResponse(
      success: json['success'],
      message: json['message'],
    );
  }
}