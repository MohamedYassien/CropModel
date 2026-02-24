import 'package:cropmodel/features/otp/data/service/otp_service.dart';

class VerifyOtpUseCase {
  final OtpService otpService;

  VerifyOtpUseCase(this.otpService);

  Future<bool> call(String otp) async {
    return await otpService.verifyOtp(otp);
  }
}
