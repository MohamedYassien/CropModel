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
        }
      } catch (e) {
        emit(ProfileLoaded(user: _createDefaultUser()));
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
        final bool changed = event.name != currentState.user.name ||
            event.phone != currentState.user.phoneNumber;
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
          profileImage: currentState.tempImage ?? currentState.user.profileImage,
        );

        try {
          await _updateProfileUseCase.call(updatedUser);
          emit(ProfileUpdateSuccess());
        } catch (e) {
          emit(ProfileError("Save Failed"));
        }
      }
    });
  }
}

UserModel _createDefaultUser() {
  return UserModel(
    name: "New User",
    email: "example@mail.com",
    phoneNumber: "0000000000",
    isFingerprintEnabled: false,
  );
}

