import 'dart:typed_data';

abstract class ProfileEvent {}

class LoadProfileEvent extends ProfileEvent {}

class ProfileImageChangedEvent extends ProfileEvent {
  final Uint8List newImage;
  ProfileImageChangedEvent(this.newImage);
}

class ProfileFieldsChangedEvent extends ProfileEvent {
  final String name;
  final String phone;
  ProfileFieldsChangedEvent({required this.name, required this.phone});
}

class SaveProfileEvent extends ProfileEvent {
  final String name;
  final String phone;
  SaveProfileEvent({required this.name, required this.phone});
}

class ToggleFingerprintEvent extends ProfileEvent {
  final bool isEnabled;
  ToggleFingerprintEvent(this.isEnabled);
}