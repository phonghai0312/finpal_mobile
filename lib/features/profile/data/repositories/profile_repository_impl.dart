import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_settings_update_request_model.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/repositories/profile_repository.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  @override
  Future<User> getUserProfile() async {
    return await remoteDataSource.getUserProfile();
  }

  @override
  Future<User> updateUserSettings(
    UserSettingsUpdateRequestModel request,
    String? name,
    String? email,
    String? phone,
  ) async {
    return await remoteDataSource.updateUserSettings(
      request,
      name,
      email,
      phone,
    );
  }

  @override
  Future<void> logout() async {
    await remoteDataSource.logout();
  }
}
