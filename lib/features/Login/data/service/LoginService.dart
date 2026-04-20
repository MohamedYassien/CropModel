import 'package:cropmodel/features/Login/data/model/LoginResponse.dart';
import '../../../../core/network/api_client.dart';
import '../model/LoginRequest.dart';
import 'LoginApi.dart';
class LoginService {
  final APIClient apiClient = APIClient();

  Future<LoginResponse?> login(LoginRequest request) async {
    print("Sending login request...");
    print("Email: $request");

    return await apiClient.fetch<Map<String, dynamic>, LoginResponse>(
      api: LoginApi.login,
      body: request.toJson(),
      mapper: (json) {
        print("response: $json");
        return LoginResponse.fromJson(json);
        },
    );
  }
}



