import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/core/domain/entities/user_settings.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_settings_update_request_model.dart';
import 'package:fridge_to_fork_ai/features/profile/data/datasources/profile_remote_data_source.dart';

class ProfileRemoteDataSourceImpl implements ProfileRemoteDataSource {
  User _mockUser = User(
    id: 'u001',
    email: 'test@example.com',
    phone: '0123456789',
    name: 'John Doe',
    avatarUrl:
        'https://www.gravatar.com/avatar/205e460b479e2e5b48aec07710c08d50?s=200',
    settings: UserSettings(
      currency: 'VND',
      language: 'vi',
      timezone: 'Asia/Ho_Chi_Minh',
      notificationEnabled: true,
    ),
    createdAt: 1678886400,
    updatedAt: 1678886400,
  );

  @override
  Future<User> getUserProfile() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockUser;
  }

  @override
  Future<User> updateUserSettings(
    UserSettingsUpdateRequestModel request,
    String? name,
    String? email,
    String? phone,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockUser = _mockUser.copyWith(
      name: name ?? _mockUser.name,
      email: email ?? _mockUser.email,
      phone: phone ?? _mockUser.phone,
      settings: _mockUser.settings?.copyWith(
        currency: request.currency ?? _mockUser.settings?.currency,
        language: request.language ?? _mockUser.settings?.language,
        timezone: request.timezone ?? _mockUser.settings?.timezone,
        notificationEnabled:
            request.notificationEnabled ??
            _mockUser.settings?.notificationEnabled,
      ),
      updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    return _mockUser;
  }

  @override
  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 500));
  }
}
