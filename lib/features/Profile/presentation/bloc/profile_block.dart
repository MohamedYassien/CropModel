import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cropmodel/core/shared/data.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase = GetProfileUseCase();
  final UpdateProfileUseCase _updateProfileUseCase = UpdateProfileUseCase();

  ProfileBloc() : super(ProfileInitial()) {
    on<LoadProfilePressed>((event, emit) async {
      final cached = AppData.instance.currentUser;
      if (cached != null) {
        emit(ProfileLoaded(user: cached));
        return;
      }

      emit(ProfileLoading());
      try {
        final user = await _getProfileUseCase.call();
        if (user != null) {
          AppData.instance.currentUser = user;
          emit(ProfileLoaded(user: user));
        } else {
          emit(ProfileError("User not found"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<ToggleFingerprintPressed>((event, emit) {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final updatedUser =
            currentState.user.copyWith(isFingerprintEnabled: event.isEnabled);
        emit(currentState.copyWith(user: updatedUser, hasChanges: true));
      }
    });

    on<ProfileImageChanged>((event, emit) {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(
            currentState.copyWith(tempImage: event.newImage, hasChanges: true));
      }
    });

    on<ProfileFieldsChanged>((event, emit) {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final bool changed = event.name != currentState.user.fullName ||
            event.phone != currentState.user.phone;
        emit(currentState.copyWith(hasChanges: changed));
      }
    });

    on<SaveProfilePressed>((event, emit) async {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(ProfileLoading());

        final updatedUser = currentState.user.copyWith(
          name: event.name,
          phoneNumber: event.phone,
          profilePicture:
              currentState.tempImage ?? currentState.user.profilePicture,
        );

        try {
          await _updateProfileUseCase.call(updatedUser);
          emit(ProfileUpdateSuccess());

          AppData.instance.currentUser = updatedUser;
          emit(ProfileLoaded(user: updatedUser, hasChanges: false));
        } catch (e) {
          emit(currentState.copyWith(
            errorMessage: "save_failed",
            hasChanges: true,
          ));
        }
      }
    });
  }
}
