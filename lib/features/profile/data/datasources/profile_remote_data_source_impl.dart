import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/profile/data/api/profile_api.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_settings_update_request_model.dart';
import 'package:fridge_to_fork_ai/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  ProfileRemoteDataSourceImpl({ProfileApi? api, ApiClient? client})
    : _api = api ?? (client ?? ApiClient()).create(ProfileApi.new);

  final ProfileApi _api;

  @override
  Future<User> getUserProfile() {
    return _guardRequest(() => _api.getCurrentUser());
  }

  @override
  Future<User> updateUserSettings(
    UserSettingsUpdateRequestModel request,
    String? name,
    String? email,
    String? phone,
  ) {
    // Swagger chỉ định UserSettingsUpdateRequest gồm các field settings,
    // nên ta chỉ gửi những trường này lên server.
    final body = request.toJson();
    return _guardRequest(() => _api.updateUserSettings(body));
  }

  @override
  Future<void> logout() async {
    // Việc xoá token đã được xử lý ở AuthNotifier; endpoint /auth/logout
    // nếu cần có thể được gọi qua AuthApi, không nằm ở module profile.
    return;
  }

  Future<T> _guardRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (dioError) {
      final dynamic data = dioError.response?.data;
      final message = (data is Map && data['message'] is String)
          ? data['message'] as String
          : dioError.message;
      throw Exception(message ?? "Unexpected server error");
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
