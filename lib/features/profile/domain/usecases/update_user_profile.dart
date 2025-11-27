import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_settings_update_request_model.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;

  UpdateUserProfileUseCase(this.repository);

  Future<User> call({
    required UserSettingsUpdateRequestModel request,
    String? name,
    String? email,
    String? phone,
  }) async {
    return await repository.updateUserSettings(request, name, email, phone);
  }
}
