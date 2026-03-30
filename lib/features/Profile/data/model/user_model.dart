import 'dart:typed_data';

class UserModel {
  final String name;
  final String email;
  final String phoneNumber;
  final Uint8List? profileImage;
  final bool isFingerprintEnabled;

  UserModel({
    required this.name,
    required this.email,
    required this.phoneNumber,
    this.profileImage,
    this.isFingerprintEnabled = false,
  });

  UserModel copyWith({
    String? name,
    String? email,
    String? phoneNumber,
    Uint8List? profileImage,
    bool? isFingerprintEnabled,
  }) {
    return UserModel(
      name: name ?? this.name,
      email: email ?? this.email,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      profileImage: profileImage ?? this.profileImage,
      isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phoneNumber: json['phone'] ?? '',
      isFingerprintEnabled: json['fingerprint_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'full_name': name,
      'email': email,
      'phone': phoneNumber,
      'fingerprint_enabled': isFingerprintEnabled,
    };
  }
}