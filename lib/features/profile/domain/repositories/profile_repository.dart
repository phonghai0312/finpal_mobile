import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';

abstract class ProfileRepository {
  /// Lấy thông tin user
  Future<User> getUser();

  /// Cập nhật thông tin cá nhân (profile)
  Future<User> updateUser(String? name, String? phone);
  Future<void> logout();
  // /// Đổi mật khẩu
  // Future<void> changePassword(
  //   String currentPassword,
  //   String newPassword,
  // );
}
