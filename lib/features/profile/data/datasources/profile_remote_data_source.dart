import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_settings_update_request_model.dart';

abstract class ProfileRemoteDataSource {
  Future<User> getUserProfile();
  Future<User> updateUserSettings(
    UserSettingsUpdateRequestModel request,
    String? name,
    String? email,
  );
  Future<void> logout();
}
