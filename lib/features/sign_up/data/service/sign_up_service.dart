import 'package:cropmodel/features/sign_up/data/model/sign_up_request.dart';
import 'package:cropmodel/features/sign_up/data/model/sign_up_response.dart';
import 'package:cropmodel/features/sign_up/data/service/sign_up_api.dart';
import '../../../../core/network/api_client.dart';

class SignUpService {
  final APIClient apiClient = APIClient();

  Future<SignUpResponse?> signUp(SignUpRequest signUpRequest) async {
    return await apiClient.fetch<SignUpRequest, SignUpResponse?>(
      api: SignUpApi.signUp,
      mapper: (response) {
        return null;
      },
    );
  }
}
