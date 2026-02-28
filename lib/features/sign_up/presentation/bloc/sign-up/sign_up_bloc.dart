import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/sign-up/sign_up_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/sign_up_usecase.dart';

class SignUpBloc extends Bloc<SignUpEvent, SignUpState> {
  SignUpBloc() : super(SignUpInitial()) {
    on<SignUpButtonPressed>((event, emit) async {
      emit(SignUpLoading());

      try {
        //await SignUpUseCase().call(event.signUpRequest);
        emit(SignUpSuccess());
      } catch (e) {
        emit(SignUpError(e.toString()));
      }
    });
  }
}