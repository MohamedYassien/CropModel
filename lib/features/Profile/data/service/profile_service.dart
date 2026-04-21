import 'package:cropmodel/features/Profile/data/service/profile_api.dart';
import 'package:dio/dio.dart' as dio;
import 'package:mime/mime.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/network/api_client.dart';
import '../model/user_model.dart';
import 'package:http_parser/http_parser.dart';

class UserService {
  final APIClient apiClient = APIClient();

  Future<UserModel?> fetchProfile() async {
    return await apiClient.fetch<void, UserModel?>(
      api: UserApi.getProfile,
      mapper: (json) => UserModel.fromJson(json),
    );
  }

  Future<void> updateProfile(UserModel user) async {
    final formData = dio.FormData.fromMap({
      'fullName': user.fullName?.trim(),
      'email': user.email,
      'phoneNumber': user.phone,
      if (user.profilePicture != null)
        'profilePicture': dio.MultipartFile.fromBytes(
          user.profilePicture!,
          // Force every file to be labeled as a .jpg
          filename: 'profile_${DateTime.now().millisecondsSinceEpoch}.jpg',
          contentType: MediaType('image', 'jpeg'),
        ),
    });
    await apiClient.fetch<dio.FormData, void>(
      api: UserApi.updateProfile,
      body: formData,
      // headers: {
      //   'Content-Type': 'multipart/form-data',
      // },
      mapper: (json) => null,
    );
  }
}