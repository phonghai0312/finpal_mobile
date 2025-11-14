import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasouces/auth_remote_datasouces.dart';
import '../../../data/repositories/auth_repositoty_impl.dart';
import '../../../domain/usecase/refresh_token_icon.dart';
import 'auth_notifier.dart';

/// DataSource
final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>(
  (ref) => AuthRemoteDataSource(),
);

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

/// Notifier
final authProvider = StateNotifierProvider<AuthNotifier, AuthState>(
  (ref) => AuthNotifier(ref.read(refreshTokenUseCaseProvider), ref),
);
