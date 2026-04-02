import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/network/API_error.dart';
import '../../domain/usecases/reset_password_usecase.dart';
import 'reset_password_event.dart';
import 'reset_password_state.dart';

class ResetPasswordBloc extends Bloc<ResetPasswordEvent, ResetPasswordState> {
  ResetPasswordBloc() : super(ResetPasswordInitial()) {
    on<ConfirmResetPasswordEvent>((event, emit) async {
      emit(ResetPasswordLoading());

      try {
        final useCase = ConfirmResetPasswordUseCase();
        final result = await useCase(
          event.newPassword,
        );
        if (result!.success) {
          emit(ResetPasswordSuccess());
        } else {
          emit(ResetPasswordError(message: result.message));
        }
      } on APIError catch (e) {
        emit(ResetPasswordError(message: e.message));
      } catch (e) {

      emit(ResetPasswordError(message: e.toString()));
    }
        }

  );
}}


