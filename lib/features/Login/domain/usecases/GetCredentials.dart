import '../../data/service/SecureStorage.dart';

class GetCredentials {
  final SecureStorage _storage;

  GetCredentials(this._storage);

  Future<Map<String, String>> call() async {
    final email = await _storage.getEmail();
    final password = await _storage.getPassword();

    return {
      'email': email,
      'password': password,
    };
  }
}
