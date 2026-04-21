import 'dart:typed_data';
import 'dart:convert';

class UserModel {
  String? userId;
  String? fullName;
  String? email;
  String? phone;
  String? role;
  Uint8List? profilePicture;
  String? status;
  bool? emailVerified;
  DateTime? createdAt;
  DateTime? updatedAt;
  bool? isFingerprintEnabled;

  UserModel({
    this.userId,
    this.fullName,
    this.email,
    this.phone,
    this.role,
    this.profilePicture,
    this.status,
    this.emailVerified,
    this.createdAt,
    this.updatedAt,
    this.isFingerprintEnabled = false,
  });

  UserModel copyWith({
    String? userId,
    String? name,
    String? email,
    String? phoneNumber,
    String? role,
    String? status,
    bool? emailVerified,
    DateTime? createdAt,
    DateTime? updatedAt,
    Uint8List? profilePicture,

    bool? isFingerprintEnabled,
  }) {
    return UserModel(
      userId: userId ?? this.userId,
      fullName: name ?? this.fullName,
      email: email ?? this.email,
      phone: phoneNumber ?? this.phone,
      role: role ?? this.role,
      profilePicture: profilePicture ?? this.profilePicture,
      status: status ?? this.status,
      emailVerified: emailVerified ?? this.emailVerified,
      createdAt: createdAt ??this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      isFingerprintEnabled: isFingerprintEnabled ?? this.isFingerprintEnabled,
    );
  }

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'],
      fullName: json['fullName'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      role: json['role'] ??'',
      profilePicture: json['profilePicture'] != null
          ? base64Decode(json['profilePicture'])
          : null,
      status: json["status"],
      emailVerified: json["emailVerified"],
      createdAt: DateTime.parse(json["createdAt"]),
      updatedAt: DateTime.parse(json["updatedAt"]),
      isFingerprintEnabled: json['fingerprint_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId':userId,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role' : role,
      'profilePicture': profilePicture != null
          ? base64Encode(profilePicture!)
          : null,
      "status": status,
      "emailVerified": emailVerified,
      "createdAt": createdAt?.toIso8601String(),
      "updatedAt": updatedAt?.toIso8601String(),
      'fingerprint_enabled': isFingerprintEnabled,
    };
  }
}