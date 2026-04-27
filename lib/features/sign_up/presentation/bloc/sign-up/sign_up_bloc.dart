import 'package:cropmodel/features/sign_up/data/model/otp/otp_request.dart';
import 'package:cropmodel/features/sign_up/domain/usecases/verify_otp_usecase.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/resend_otp_usecase.dart';
import '../../../domain/usecases/sign_up_usecase.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final VerifyOtpUseCase _verifyOtpUseCase = VerifyOtpUseCase();

  SignUpBloc() : super(SignUpInitial()) {

    on<SignUpButtonPressed>((event, emit) async {
      emit(SignUpLoading());
      try {
        await SignUpUseCase().call(event.signUpRequest);
        emit(SignUpSuccess());
      } catch (e) {
        String errorMessage = e.toString();
        if(e.toString().contains('Email already exists')){
          errorMessage = 'email_already_exists'.tr();
        } else if (e.toString().contains('No internet connection')){
          errorMessage = "no_internet_connection".tr();
        }
        emit(SignUpError(errorMessage));
      }
    });


    on<VerifyOtpSubmitted>((event, emit) async {
      emit(SignUpLoading());
      try {
        final response = await _verifyOtpUseCase.call(

          OTPRequest(
            email: event.email ?? '',
            otp: event.otp ?? '',
          ),
        );

        if (response != null && response.success == true) {
          emit(SignUpSuccess());
        } else {

          emit(SignUpError(response?.message ?? "Invalid verification code."));
        }
      } catch (e) {
        emit(SignUpError("The Otp Is Error"));
      }
    });

    on<OTPResendButtonPressed>((event, emit) async {
      emit(SignUpLoading());
      try {
        await ResendOtpUseCase().call(event.email);

        emit(OTPResendSuccess());
      } catch (e) {
        emit(OTPResendError(e.toString()));
      }
    });
  }
}