import 'package:cropmodel/features/Profile/data/service/profile_api.dart';
import 'package:dio/dio.dart' as dio;
import '../../../../core/network/api_client.dart';
import 'package:http_parser/http_parser.dart';
import '../model/user_model.dart';

class UserService {
  final APIClient apiClient = APIClient();

  Future<UserModel?> fetchProfile() async {
    return await apiClient.fetch<void, UserModel?>(
      api: UserApi.getProfile,
      mapper: (json) => UserModel.fromJson(json),
    );
  }

  Future<void> updateProfile(UserModel user) async {
    final Map<String, dynamic> body = {
      'fullName': user.fullName?.trim() ?? '',
      'email': user.email ?? '',
    };

    if (user.profilePicture != null && user.profilePicture!.isNotEmpty) {
      body['profilePicture'] = dio.MultipartFile.fromBytes(
        user.profilePicture!,
        filename: 'profile.jpg',
        contentType: MediaType('image', 'jpeg'),
      );
    }

    body['phoneNumber'] = user.phone ?? '';

    await apiClient.fetch<dio.FormData, void>(
      api: UserApi.updateProfile,
      body: dio.FormData.fromMap(body),
      mapper: (_) {},
    );
  }
}