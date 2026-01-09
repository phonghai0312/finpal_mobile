import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:finpal/core/network/api_client.dart';
import 'package:finpal/features/profile/data/api/profile_api.dart';
import 'package:finpal/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:finpal/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:finpal/features/profile/domain/usecases/get_user_profile.dart';
import 'package:finpal/features/profile/domain/usecases/logout.dart';

import 'package:finpal/features/profile/presentation/provider/profile/profile_notifier.dart';

/// -------------------------------------------------------
/// API
/// -------------------------------------------------------
final profileApiProvider = Provider<ProfileApi>((ref) {
  return ApiClient().create(ProfileApi.new);
});

/// -------------------------------------------------------
/// DATASOURCE
/// -------------------------------------------------------
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSource(ref.read(profileApiProvider)),
);

/// -------------------------------------------------------
/// REPOSITORY
/// -------------------------------------------------------
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>((ref) {
  return ProfileRepositoryImpl(
    remoteDataSource: ref.read(profileRemoteDataSourceProvider),
  );
});

/// -------------------------------------------------------
/// USECASES (chỉ giữ những cái ProfileNotifier cần)
/// -------------------------------------------------------
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>((ref) {
  return GetUserProfileUseCase(ref.read(profileRepositoryProvider));
});

final logoutUseCaseProvider = Provider<LogoutUseCase>((ref) {
  return LogoutUseCase(ref.read(profileRepositoryProvider));
});

/// -------------------------------------------------------
/// NOTIFIER PROVIDER (đúng với ProfileNotifier mới)
/// -------------------------------------------------------
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
      (ref) => ProfileNotifier(
        ref.read(getUserProfileUseCaseProvider),
        ref.read(logoutUseCaseProvider),
        ref,
      ),
    );
