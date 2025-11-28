import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/profile/data/api/profile_api.dart';
import 'package:fridge_to_fork_ai/features/profile/data/datasources/profile_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/profile/data/datasources/profile_remote_data_source_impl.dart';
import 'package:fridge_to_fork_ai/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/usecases/get_user_profile.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/usecases/logout.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/usecases/update_user_profile.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_notifier.dart';

/// Retrofit Api With Dio
final profileApiProvider = Provider<ProfileApi>((ref) {
  return ApiClient().create(ProfileApi.new);
});

/// DataSource
final profileRemoteDataSourceProvider = Provider<ProfileRemoteDataSource>(
  (ref) => ProfileRemoteDataSourceImpl(api: ref.read(profileApiProvider)),
);

/// Repository
final profileRepositoryProvider = Provider<ProfileRepositoryImpl>(
  (ref) => ProfileRepositoryImpl(
    remoteDataSource: ref.read(profileRemoteDataSourceProvider),
  ),
);

/// UseCases
final getUserProfileUseCaseProvider = Provider<GetUserProfileUseCase>(
  (ref) => GetUserProfileUseCase(ref.read(profileRepositoryProvider)),
);

final updateUserSettingsUseCaseProvider = Provider<UpdateUserProfileUseCase>(
  (ref) => UpdateUserProfileUseCase(ref.read(profileRepositoryProvider)),
);

final logoutUseCaseProvider = Provider<LogoutUseCase>(
  (ref) => LogoutUseCase(ref.read(profileRepositoryProvider)),
);

/// Notifier Provider
final profileNotifierProvider =
    StateNotifierProvider<ProfileNotifier, ProfileState>(
      (ref) => ProfileNotifier(
        ref.read(getUserProfileUseCaseProvider),
        ref.read(updateUserSettingsUseCaseProvider),
        ref.read(logoutUseCaseProvider),
        ref,
      ),
    );
