import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/API_error.dart';
import '../../domain/usecases/change_password_usecase.dart';
import 'Change_password_event.dart';
import 'Change_password_state.dart';

class ChangePasswordBloc extends Bloc<ChangePasswordEvent, ChangePasswordState> {
  ChangePasswordBloc() : super(ResetPasswordInitial()) {
    on<ConfirmResetPasswordEvent>((event, emit) async {
      emit(ResetPasswordLoading());

      try {
        final useCase = ConfirmResetPasswordUseCase();
        final result = await useCase(
          event.newPassword,
        );
        if (result != null && result.success) {
          emit(ResetPasswordSuccess());
        } else {
          emit(ResetPasswordError(message: result?.message ?? "An error occurred"));
        }
      } on APIError catch (e) {
        emit(ResetPasswordError(message: e.message));
      } catch (e) {
        emit(ResetPasswordError(message: e.toString()));
      }
    });
  }
}
