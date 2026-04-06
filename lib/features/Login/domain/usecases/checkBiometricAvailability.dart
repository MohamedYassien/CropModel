// import 'dart:ffi';

import 'package:cropmodel/features/Login/data/service/BiometricService.dart';

class CheckBiometricAvailabilty{

  final BiometricService biometricService = BiometricService();

  Future<bool>call()async {
   return await biometricService.checkBiometricAvailability();
  }

}