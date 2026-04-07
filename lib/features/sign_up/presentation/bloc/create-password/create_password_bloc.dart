import 'package:cropmodel/features/sign_up/domain/usecases/create_password_usecase.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/create-password/create_password_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/create-password/create_password_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CreatePasswordBloc extends Bloc<CreatePasswordEvent, CreatePasswordState>{
  CreatePasswordBloc() : super(CreatePasswordInitial()) {
    on<CreatePasswordButtonPressed>((event, emit) async {
      emit(CreatePasswordLoading());
      try {
        await Future.delayed(Duration(seconds: 2));
        // await CreatePasswordUseCase().call(event.password);
        emit(CreatePasswordSuccess());
      } catch (e) {
        emit(CreatePasswordError(e.toString()));
      }
    });
  }
}