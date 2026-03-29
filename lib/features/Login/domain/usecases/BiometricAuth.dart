import '../../data/service/BiometricService.dart';

class Biometricauth {

  final  BiometricService _biometricservice;
  Biometricauth(this._biometricservice);

  Future<bool>call()async{
    return await _biometricservice.authenticate();
  }

}