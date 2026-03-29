import '../../data/service/SecureStorage.dart';

class Savecredentials {

  final SecureStorage _storage;
   Savecredentials(this._storage);

   Future<void>call(String email,String password)async{
     await _storage.saveEmail(email);
     await _storage.savePassword(password);
  }
}