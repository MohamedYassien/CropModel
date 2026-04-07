class CreatePasswordRequest {
  final String password;

  CreatePasswordRequest({
    required this.password,
  });

  Map<String, dynamic> toJson() {
    return {
      'password': password,
    };
  }
}