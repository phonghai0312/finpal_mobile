import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/api/transaction_api.dart';
import '../../../data/datasources/transaction_remote_datasources.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../domain/usecase/create_transaction.dart';
import 'create_transaction_notifier.dart';

/// ===============================
/// API PROVIDER
/// ===============================
final createTransactionApiProvider = Provider<TransactionApi>(
  (ref) => ApiClient().create(TransactionApi.new),
);

/// ===============================
/// DATASOURCE PROVIDER
/// ===============================
final createTransactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSource(
        api: ref.read(createTransactionApiProvider),
      ),
    );

/// ===============================
/// REPOSITORY PROVIDER
/// ===============================
final createTransactionRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) => TransactionRepositoryImpl(
    ref.read(createTransactionRemoteDataSourceProvider),
  ),
);

/// ===============================
/// USECASE PROVIDER
/// ===============================
final createTransactionUsecaseProvider = Provider<CreateTransaction>(
  (ref) => CreateTransaction(ref.read(createTransactionRepositoryProvider)),
);

/// ===============================
/// NOTIFIER PROVIDER
/// ===============================
final createTransactionNotifierProvider =
    StateNotifierProvider<CreateTransactionNotifier, CreateTransactionState>(
      (ref) => CreateTransactionNotifier(
        ref.read(createTransactionUsecaseProvider),
      ),
    );
