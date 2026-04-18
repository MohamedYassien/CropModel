import 'package:cropmodel/features/sign_up/domain/usecases/create_password_usecase.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/create-password/create_password_event.dart';
import 'package:cropmodel/features/sign_up/presentation/bloc/create-password/create_password_state.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/create-password/create_password_request.dart';

class CreatePasswordBloc
    extends Bloc<CreatePasswordEvent, CreatePasswordState> {
  CreatePasswordBloc() : super(CreatePasswordInitial()) {
    on<CreatePasswordButtonPressed>((event, emit) async {
      emit(CreatePasswordLoading());
      try {
        await CreatePasswordUseCase().call(
          CreatePasswordRequest(
            email: event.email,
            otp: event.otp,
            password: event.password,
          ),
        );
        emit(CreatePasswordSuccess());
      } catch (e) {
        String errorMessage = e.toString();
        if (e.toString().contains('No internet connection')) {
          errorMessage = "no_internet_connection".tr();
        }
        emit(CreatePasswordError(errorMessage));
      }
    });
  }
}
