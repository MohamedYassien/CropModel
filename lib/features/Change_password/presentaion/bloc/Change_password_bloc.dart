import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/network/API_error.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'Change_password_event.dart';
import 'Change_password_state.dart';

class ChangePasswordBloc
    extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  final ChangePasswordUseCase changePasswordUseCase;

  ChangePasswordBloc({required this.changePasswordUseCase})
    : super(ChangePasswordInitial()) {
    on<ChangePasswordSubmitted>((event, emit) async {
      emit(ChangePasswordLoading());

      try {
        final response = await changePasswordUseCase.call(
          email: event.email,
          currentPassword: event.currentPassword,
          newPassword: event.newPassword,
        );
        emit(ChangePasswordSuccess(message: response.message));
      } on APIError catch (e) {
        emit(ChangePasswordError(message: e.message));
      } catch (e) {
        emit(ChangePasswordError(message: e.toString()));
      }
    });
  }
}
