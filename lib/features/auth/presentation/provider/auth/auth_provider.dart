import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/auth_api.dart';
import '../../../data/datasouces/auth_remote_datasouces.dart';
import '../../../data/repositories/auth_repositoty_impl.dart';
import '../../../domain/usecase/refresh_token_icon.dart';
import '../../../domain/usecase/deactive_fcm_token.dart';
import 'auth_notifier.dart';

/// Retrofit Api With Dio
final authApiProvider = Provider<AuthApi>((ref) {
  return ApiClient().create(AuthApi.new);
});

/// DataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(api: ref.read(authApiProvider));
});

/// Repository
final authRepositoryProvider = Provider<AuthRepositoryImpl>(
  (ref) => AuthRepositoryImpl(
    remoteDataSource: ref.read(authRemoteDataSourceProvider),
  ),
);

/// UseCase refresh token
final refreshTokenUseCaseProvider = Provider<RefreshTokenAccount>(
  (ref) => RefreshTokenAccount(ref.read(authRepositoryProvider)),
);

/// UseCase deactive FCM token
final deactiveFcmTokenUseCaseProvider = Provider<DeactiveFcmToken>(
  (ref) => DeactiveFcmToken(ref.read(authRepositoryProvider)),
);

/// Notifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(
    ref.read(refreshTokenUseCaseProvider),
    ref.read(deactiveFcmTokenUseCaseProvider),
    ref,
  ),
);
