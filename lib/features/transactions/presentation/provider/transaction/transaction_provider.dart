import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/api/transaction_api.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../domain/usecase/get_transactions.dart';
import '../../../domain/usecase/get_spend_amounts.dart';
import 'transaction_notifier.dart';

/// ===============================
/// API PROVIDER
/// ===============================
final transactionApiProvider = Provider<TransactionApi>(
  (ref) => ApiClient().create(TransactionApi.new),
);

/// ===============================
/// DATASOURCE PROVIDER
/// ===============================
final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSource(
        api: ref.read(transactionApiProvider),
      ),
    );

/// ===============================
/// REPOSITORY PROVIDER
/// ===============================
final transactionRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) =>
      TransactionRepositoryImpl(ref.read(transactionRemoteDataSourceProvider)),
);

/// ===============================
/// USECASE PROVIDER
/// ===============================
final getTransactionsProvider = Provider<GetTransactions>(
  (ref) => GetTransactions(ref.read(transactionRepositoryProvider)),
);

final getSpendAmountsUseCaseProvider = Provider<GetSpendAmounts>(
  (ref) => GetSpendAmounts(ref.read(transactionRepositoryProvider)),
);

/// ===============================
/// NOTIFIER PROVIDER
/// ===============================
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
      (ref) => TransactionNotifier(ref.read(getTransactionsProvider), ref),
    );
