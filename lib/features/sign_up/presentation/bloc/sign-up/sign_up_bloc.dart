import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/usecases/sign_up_usecase.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
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
  }
}