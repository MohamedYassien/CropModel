import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorage {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  Future<void> saveEmail(String email) async {
    await _storage.write(key: 'email', value: email);
  }

  Future<void> savePassword(String password) async {
    await _storage.write(key: 'password', value: password);
  }

  Future<String> getEmail() async {
    return await _storage.read(key: 'email') ?? '';
  }

  Future<String> getPassword() async {
    return await _storage.read(key: 'password') ?? '';
  }

  Future<void> clearData() async {
    await _storage.delete(key: 'email');
    await _storage.delete(key: 'password');
    await _storage.delete(key: 'token');
  }

  Future<void> setBiometricEnabled(bool value) async {
    await _storage.write(key: 'biometric_enabled', value: value.toString());
  }

  Future<bool> isBiometricEnabled() async {
    final value = await _storage.read(key: 'biometric_enabled');
    return value == 'true';
  }

  Future<void> setBiometricPromptShown(bool value) async {
    await _storage.write(
      key: 'biometric_prompt_shown',
      value: value.toString(),
    );
  }

  Future<bool> isBiometricPromptShown() async {
    final value = await _storage.read(key: 'biometric_prompt_shown');
    return value == 'true';
  }

  Future<void> saveToken(String token) async{
    await _storage.write(key:'token',value:token);
  }

  Future<String>getToken()async{
    return await _storage.read(key: 'token') ?? '';
  }
}
