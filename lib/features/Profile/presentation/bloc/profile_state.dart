import 'dart:typed_data';
import '../../data/model/user_model.dart';

class ProfileState {
  final UserModel? user;
  final bool isLoading;
  final String? errorMessage;
  final bool hasChanges;
  final Uint8List? tempImage;

  ProfileState({
    this.user,
    this.isLoading = false,
    this.errorMessage,
    this.hasChanges = false,
    this.tempImage,
  });

  ProfileState copyWith({
    UserModel? user,
    bool? isLoading,
    String? errorMessage,
    bool? hasChanges,
    Uint8List? tempImage,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage ?? this.errorMessage,
      hasChanges: hasChanges ?? this.hasChanges,
      tempImage: tempImage ?? this.tempImage,
    );
  }
}