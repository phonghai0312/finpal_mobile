import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasouces/auth_remote_datasouces.dart';
import '../../../data/repositories/auth_repositoty_impl.dart';
import '../../../domain/usecase/send_request.dart';
import 'send_request_notifier.dart';

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
final sendRequestUseCaseProvider = Provider<SendRequest>(
  (ref) => SendRequest(ref.read(authRepositoryProvider)),
);

/// Notifier
final sendRequestNotifierProvider =
    StateNotifierProvider<SendRequestNotifier, SendRequestState>(
      (ref) => SendRequestNotifier(ref.read(sendRequestUseCaseProvider)),
    );
