import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/auth/data/repositories/auth_repositoty_impl.dart'
    show AuthRepositoryImpl;

import '../../../data/datasouces/auth_remote_datasouces.dart';
import '../../../domain/usecase/login_account.dart';
import 'login_notifier.dart';

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

/// UseCase login
final loginUseCaseProvider = Provider<LoginAccount>(
  (ref) => LoginAccount(ref.read(authRepositoryProvider)),
);

/// Notifier
final loginNotifierProvider = StateNotifierProvider<LoginNotifier, LoginState>(
  (ref) => LoginNotifier(ref.read(loginUseCaseProvider), ref),
);
