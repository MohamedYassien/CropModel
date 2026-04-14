import '../../../../core/network/api_client.dart';
import 'LoginApi.dart';

class LoginService {
  final APIClient apiClient = APIClient();

  Future<void> login(String email, String password) async {
    await apiClient.fetch<Map<String, dynamic>, void>(
      api: LoginApi.login,
      body: {
        "email": email,
        "password": password,
      },
      mapper: (_) {},
    );
  }
}