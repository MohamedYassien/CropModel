import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/model/user_model.dart';
import '../../domain/usecases/get_user_profile_usecase.dart';
import '../../domain/usecases/update_profile_usecase.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final GetProfileUseCase _getProfileUseCase = GetProfileUseCase();
  final UpdateProfileUseCase _updateProfileUseCase = UpdateProfileUseCase();

  ProfileBloc() : super(ProfileInitial()) {

    on<LoadProfilePressed>((event, emit) async {
      emit(ProfileLoading());
      try {
        final user = await _getProfileUseCase.call();
        if (user != null) {
          emit(ProfileLoaded(user: user));
        }else {
          emit(ProfileError("User not found"));
        }
      } catch (e) {
        emit(ProfileError(e.toString()));
      }
    });

    on<ToggleFingerprintPressed>((event, emit) {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        final updatedUser = currentState.user.copyWith(isFingerprintEnabled: event.isEnabled);
        emit(currentState.copyWith(user: updatedUser, hasChanges: true));
      }
    });

    on<ProfileImageChanged>((event, emit) {
      if (state is ProfileLoaded) {
        final currentState = state as ProfileLoaded;
        emit(currentState.copyWith(tempImage: event.newImage, hasChanges: true));
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
        final newImage = currentState.tempImage ?? currentState.user.profilePicture;
        emit(ProfileLoading());

        final updatedUser = currentState.user.copyWith(
          name: event.name,
          phoneNumber: event.phone,
          profilePicture: currentState.tempImage ?? currentState.user.profilePicture,
        );

        try {

          await _updateProfileUseCase.call(updatedUser);
          emit(ProfileUpdateSuccess());

          final freshUser = await _getProfileUseCase.call();

          if (freshUser != null) {
            emit(ProfileLoaded(user: freshUser, hasChanges: false));
          }
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


