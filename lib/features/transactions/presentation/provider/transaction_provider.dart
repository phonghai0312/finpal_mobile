import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/datasources/transaction_remote_datasources.dart';
import '../../data/datasources/transaction_remote_datasources_impl.dart';
import '../../data/repositories/transaction_repository_impl.dart';
import '../../domain/usecase/get_transactions.dart';
import 'transaction_notifier.dart';

/// DataSource
///
/// //note: ref la doi tuong m Riverpod cung cap cho moi provider, dung ref de doc cac provider khac: ref.read(), lắng nghe provider khac: ref.watch().
final transactionRemoteDataSourceProvider = Provider<TransactionRemoteDataSource>(
  (ref) => TransactionRemoteDataSourceImpl(),
);

/// Repository
final transactionRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) => TransactionRepositoryImpl(
    remoteDataSource: ref.read(transactionRemoteDataSourceProvider),
  ),
);

/// UseCase
final getTransactionsUseCaseProvider = Provider<GetTransactions>(
  (ref) => GetTransactions(ref.read(transactionRepositoryProvider)),
);

/// Notifier
final transactionNotifierProvider = StateNotifierProvider<TransactionNotifier, TransactionState>(
  (ref) => TransactionNotifier(ref.read(getTransactionsUseCaseProvider))
);
