import '../api/profile_api.dart';
import '../models/user_model.dart';

class ProfileRemoteDataSource {
  final ProfileApi api;

  ProfileRemoteDataSource(this.api);

  /// GET USER
  Future<UserModel> getUser() {
    return api.getCurrentUser();
  }

  /// UPDATE PROFILE
  Future<UserModel> updateUser({String? name, String? phone}) {
    final body = <String, dynamic>{};

    if (name != null) body['name'] = name;
    if (phone != null) body['phone'] = phone;
    return api.updateUserProfile(body);
  }

  Future<void> logout() {
    return api.logout();
  }

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
}
