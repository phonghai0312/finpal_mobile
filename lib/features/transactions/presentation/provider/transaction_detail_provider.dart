import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources_impl.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transaction_detail.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_notifier.dart';

/// DataSource
final transactionRemoteDataSourceProvider =
Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSourceImpl(),
);

/// Repository
final transactionRepositoryProvider =
Provider<TransactionRepositoryImpl>(
      (ref) => TransactionRepositoryImpl(
    remoteDataSource: ref.read(transactionRemoteDataSourceProvider),
  ),
);

/// UseCase
final getTransactionDetailUseCaseProvider =
Provider<GetTransactionDetail>(
      (ref) => GetTransactionDetail(
    ref.read(transactionRepositoryProvider),
  ),
);

/// Notifier Provider (FAMILY)
final transactionNotifierProvider = StateNotifierProvider.family<
    TransactionDetailNotifier,
    TransactionDetailState,
    String>(
      (ref, transactionId) {
    final usecase = ref.read(getTransactionDetailUseCaseProvider);
    return TransactionDetailNotifier(usecase, transactionId);
  },
);

