import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/service/user_service.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final UserRepository userRepository;

  ProfileBloc(this.userRepository) : super(ProfileState()) {

    on<ToggleFingerprintEvent>((event, emit) {
      if (state.user != null) {
        final updatedUser = state.user!.copyWith(isFingerprintEnabled: event.isEnabled);

        emit(state.copyWith(
          user: updatedUser,
          hasChanges: true,
        ));
      }
    });

    on<LoadProfileEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      try {
        final user = await userRepository.getProfile();
        emit(state.copyWith(user: user, isLoading: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: e.toString()));
      }
    });

    on<ProfileImageChangedEvent>((event, emit) {
      emit(state.copyWith(
        tempImage: event.newImage,
        hasChanges: true,
      ));
    });

    on<ProfileFieldsChangedEvent>((event, emit) {
      if (state.user != null) {
        final bool changed = event.name != state.user!.name ||
            event.phone != state.user!.phoneNumber;
        emit(state.copyWith(hasChanges: changed));
      }
    });

    on<SaveProfileEvent>((event, emit) async {
      emit(state.copyWith(isLoading: true));
      final updatedUser = state.user!.copyWith(
        name: event.name,
        phoneNumber: event.phone,
        profileImage: state.tempImage ?? state.user!.profileImage,
      );

      try {
        await userRepository.updateProfile(updatedUser);
        emit(state.copyWith(user: updatedUser, isLoading: false, hasChanges: false));
      } catch (e) {
        emit(state.copyWith(isLoading: false, errorMessage: "Save Failed"));
      }
    });
  }
}