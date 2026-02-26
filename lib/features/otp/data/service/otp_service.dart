class OtpService {
  Future<bool> verifyOtp(String otp) async {
    await Future.delayed(Duration(seconds: 1));
    return otp == "123456"; 
  }
}
