import 'package:cropmodel/features/ForgotPassword/domain/usecases/resend_otp_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/usecases/reset_password_usecase.dart';
import '../../domain/usecases/send_otp_usecase.dart';
import '../../domain/usecases/verify_otp_usecase.dart';

import '../../../../core/network/API_error.dart';

import 'forgotPass_event.dart';
import 'forgotPass_state.dart';

class ForgotPassBloc extends Bloc<ForgotPassEvent, ForgotPassState> {

  ForgotPassBloc() : super(ForgotPassInitial()) {
    on<SendOtpEvent>((event, emit) async {
      emit(ForgotPassLoading());
      try {
        await SendOtpUseCase().call(event.email);
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
        await VerifyOtpUseCase().call(event.email, event.otp);
        emit(OTPVerifySuccess());
      } on APIError catch (e) {
        emit(ForgotPassError(e.message));
      } catch (e) {
        emit(ForgotPassError(e.toString()));
      }
    });

    on<ResetPasswordEvent>((event, emit) async {
      emit(ForgotPassLoading());
      try {
        await ResetPasswordUseCase().call(
          event.email,
          event.otp,
          event.password
        );
        emit(PasswordResetState());
      } on APIError catch (e) {
        emit(ForgotPassError(e.message));
      } catch (e) {
        emit(ForgotPassError(e.toString()));
      }
    });

    on<OTPResendButtonPressed>((event, emit) async {
      emit(OTPResendLoading());
      try {
        await ResendOtpUsecase().call(event.email);
        emit(OTPResendSuccess());
      } catch (e) {
        emit(OTPVerifyError(e.toString()));
      }
    });
  }
}
