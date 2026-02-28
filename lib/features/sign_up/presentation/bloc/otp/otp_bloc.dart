import 'package:cropmodel/features/sign_up/data/model/otp/otp_request.dart';
import 'package:cropmodel/features/sign_up/domain/usecases/resend_otp_usecase.dart';
import 'package:cropmodel/features/sign_up/domain/usecases/verify_otp_usecase.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/otp/otp_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/otp/otp_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class OTPBloc extends Bloc<OTPEvent, OTPState> {
  OTPBloc() : super(OTPInitial()) {
    on<OTPButtonPressed>((event, emit) async {
      emit(OTPVerifyLoading());
      try {

        await VerifyOtpUseCase().call(OTPRequest(otp: event.otp, email: event.email));
        emit(OTPVerifySuccess());
      } catch (e) {
        emit(OTPVerifyError(e.toString()));
      }
    });

    on<OTPResendButtonPressed>((event, emit) async {
      emit(OTPResendLoading());
      try {
        //await ResendOtpUseCase().call(event.email);
        emit(OTPResendSuccess());
      } catch (e) {
        emit(OTPResendError(e.toString()));
      }
    });
  }
}
