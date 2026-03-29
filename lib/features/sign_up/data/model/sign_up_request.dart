class SignUpRequest {
  final String name;
  final String email;
  final String phone;

  SignUpRequest({
    required this.name,
    required this.email,
    required this.phone,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
    };
  }

  factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      name: json['name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
    );
  }
}