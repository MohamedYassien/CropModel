import 'package:flutter_bloc/flutter_bloc.dart';
import 'otp_event.dart';
import 'otp_state.dart';
import 'package:cropmodel/features/otp/domain/usecases/verify_otp_usecase.dart';

class OtpBloc extends Bloc<OtpEvent, OtpState> {
  final VerifyOtpUseCase verifyOtpUseCase;

  OtpBloc(this.verifyOtpUseCase) : super(OtpInitial()) {
    on<SubmitOtpEvent>((event, emit) async {
      emit(OtpLoading());

      bool result = await verifyOtpUseCase.call(event.otp);

      if (result) {
        emit(OtpSuccess());
      } else {
        emit(OtpFailure("OTP is incorrect"));
      }
    });
  }
}
