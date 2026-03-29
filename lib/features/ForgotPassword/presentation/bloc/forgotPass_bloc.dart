import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';
import '../../domain/usecases/reset_password_usecase.dart';

import '../../../../core/network/API_error.dart';

import 'forgotPass_event.dart';
import 'forgotPass_state.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {
  final SendOtpUseCase sendOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final ResetPasswordUseCase resetPasswordUseCase;

  ForgotPassBloc({
    required this.sendOtpUseCase,
    required this.verifyOtpUseCase,
    required this.resetPasswordUseCase,
  }) : super(ForgotPassInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(ForgotPassLoading());
      try {
        await sendOtpUseCase.call(event.email);
        emit(OtpSentState());
      } on APIError catch (e) {
        emit(ForgotPassError(e.message));
      } catch (e) {
        emit(ForgotPassError(e.toString()));
      }
    });

    on<VerifyOtpEvent>((event, emit) async {
      emit(ForgotPassLoading());
      try {
        await verifyOtpUseCase.call(event.email, event.otp);
        emit(OtpVerifiedState());
      } on APIError catch (e) {
        emit(ForgotPassError(e.message));
      } catch (e) {
        emit(ForgotPassError(e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(ForgotPassLoading());
      try {
        await resetPasswordUseCase.call(event.email, event.password);
        emit(PasswordResetState());
      } on APIError catch (e) {
        emit(ForgotPassError(e.message));
      } catch (e) {
        emit(ForgotPassError(e.toString()));
      }
    });
  }
}
