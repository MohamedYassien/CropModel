import 'dart:typed_data';
import '../../data/model/user_model.dart';

abstract class ProfileState {}

class ProfileInitial extends ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final UserModel user;
  final bool hasChanges;
  final Uint8List? tempImage;
  final String? errorMessage;

  ProfileLoaded({
    required this.user,
    this.hasChanges = false,
    this.tempImage,
    this.errorMessage,
  });

  ProfileLoaded copyWith({
    UserModel? user,
    bool? hasChanges,
    Uint8List? tempImage,
    String? errorMessage,
  }) {
    return ProfileLoaded(
      user: user ?? this.user,
      hasChanges: hasChanges ?? this.hasChanges,
      tempImage: tempImage ?? this.tempImage,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class ProfileUpdateSuccess extends ProfileState {}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}