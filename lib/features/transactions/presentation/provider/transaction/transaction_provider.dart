import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/transaction_remote_datasources.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../domain/usecase/get_transactions.dart';
import 'transaction_notifier.dart';

/// ===============================
/// DATASOURCE PROVIDER
/// ===============================
final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSource(),
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

/// ===============================
/// NOTIFIER PROVIDER
/// ===============================
final transactionNotifierProvider =
    StateNotifierProvider<TransactionNotifier, TransactionState>(
      (ref) => TransactionNotifier(ref.read(getTransactionsProvider), ref),
    );
