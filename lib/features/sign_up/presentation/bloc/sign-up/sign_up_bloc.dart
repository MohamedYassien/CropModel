import 'package:cropmodel/features/sign_up/data/model/otp/otp_request.dart';
import 'package:cropmodel/features/sign_up/domain/usecases/verify_otp_usecase.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/sign_up_usecase.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {

  final VerifyOtpUseCase _verifyOtpUseCase = VerifyOtpUseCase();

  SignUpBloc() : super(SignUpInitial()) {

    on<SignUpButtonPressed>((event, emit) async {
      emit(SignUpLoading());
      try {
        await Future.delayed(const Duration(seconds: 2));
        //await SignUpUseCase().call(event.signUpRequest);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpError("Registration failed. Please try again."));
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
  }
}