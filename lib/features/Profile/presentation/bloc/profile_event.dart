import 'dart:typed_data';

abstract class ProfileEvent {}

class LoadProfilePressed extends ProfileEvent {}

class ToggleFingerprintPressed extends ProfileEvent {
  final bool isEnabled;
  ToggleFingerprintPressed(this.isEnabled);
}

class ProfileImageChanged extends ProfileEvent {
  final Uint8List newImage;
  ProfileImageChanged(this.newImage);
}

class ProfileFieldsChanged extends ProfileEvent {
  final String name;
  final String phone;
  ProfileFieldsChanged({required this.name, required this.phone});
}

class SaveProfilePressed extends ProfileEvent {
  final String name;
  final String phone;
  SaveProfilePressed({required this.name, required this.phone});
}