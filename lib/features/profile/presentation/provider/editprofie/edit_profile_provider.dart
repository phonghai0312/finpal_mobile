import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finpal/core/network/api_client.dart';
import 'package:finpal/features/profile/data/api/profile_api.dart';
import 'package:finpal/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:finpal/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:finpal/features/profile/domain/usecases/update_user_profile.dart';

import 'edit_profile_notifier.dart';

/// =========================================================
/// 1. API PROVIDER
/// =========================================================
final editProfileApiProvider = Provider<ProfileApi>((ref) {
  return ApiClient().create(ProfileApi.new);
});

/// =========================================================
/// 2. REMOTE DATA SOURCE
/// =========================================================
final editProfileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>((
  ref,
) {
  return ProfileRemoteDataSource(ref.read(editProfileApiProvider));
});

/// =========================================================
/// 3. REPOSITORY
/// =========================================================
final editProfileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.read(editProfileRemoteDataSourceProvider),
  );
});

/// =========================================================
/// 4. USE CASE
/// =========================================================
final updateUserProfileUseCaseProvider = Provider<UpdateUserProfileUseCase>((
  ref,
) {
  return UpdateUserProfileUseCase(ref.read(editProfileRepositoryProvider));
});

/// =========================================================
/// 5. NOTIFIER PROVIDER
/// =========================================================
final editProfileNotifierProvider =
    StateNotifierProvider<EditProfileNotifier, EditProfileState>((ref) {
      return EditProfileNotifier(
        ref.read(updateUserProfileUseCaseProvider),
        ref,
      );
    });
