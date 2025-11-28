import 'package:dio/dio.dart';

import '../api/profile_api.dart';
import '../models/user_model.dart';

class ProfileRemoteDataSource {
  final ProfileApi api;

  ProfileRemoteDataSource(this.api);

  /// GET USER
  Future<UserModel> getUser() => _guardRequest(api.getCurrentUser);

  /// UPDATE PROFILE
  Future<UserModel> updateUser({String? name, String? phone}) {
    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    return _guardRequest(() => api.updateUserProfile(body));
  }

  Future<void> logout() => _guardRequest(api.logout);

  // /// CHANGE PASSWORD
  // Future<void> changePassword({
  //   required String currentPassword,
  //   required String newPassword,
  // }) {
  //   return api.changePassword({
  //     'currentPassword': currentPassword,
  //     'password': newPassword,
  //   });
  // }
  Future<T> _guardRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (dioError) {
      final dynamic data = dioError.response?.data;
      final message = (data is Map && data['message'] is String)
          ? data['message'] as String
          : dioError.message;
      throw Exception(message ?? 'Unexpected server error');
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
