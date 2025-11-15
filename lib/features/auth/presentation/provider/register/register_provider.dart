import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../data/datasouces/auth_remote_datasouces.dart';
import '../../../data/repositories/auth_repositoty_impl.dart';
import '../../../domain/usecase/register_account.dart';
import 'register_notifier.dart';

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

/// UseCase
final registerUseCaseProvider = Provider<RegisterAccount>(
  (ref) => RegisterAccount(ref.read(authRepositoryProvider)),
);

/// Notifier
final registerNotifierProvider =
    StateNotifierProvider<RegisterNotifier, RegisterState>(
      (ref) => RegisterNotifier(ref.read(registerUseCaseProvider), ref),
    );
