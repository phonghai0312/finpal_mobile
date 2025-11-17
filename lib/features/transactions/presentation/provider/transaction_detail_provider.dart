import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources_impl.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transaction_detail.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_notifier.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/delete_transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/update_transaction.dart';

/// DataSource
final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSourceImpl(),
    );

/// Repository
final transactionRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) => TransactionRepositoryImpl(
    remoteDataSource: ref.read(transactionRemoteDataSourceProvider),
  ),
);

/// UseCase
final getTransactionDetailUseCaseProvider = Provider<GetTransactionDetail>(
  (ref) => GetTransactionDetail(ref.read(transactionRepositoryProvider)),
);

final deleteTransactionUseCaseProvider = Provider<DeleteTransaction>(
  (ref) => DeleteTransaction(ref.read(transactionRepositoryProvider)),
);

final updateTransactionUseCaseProvider = Provider<UpdateTransactionUseCase>(
  (ref) => UpdateTransactionUseCase(ref.read(transactionRepositoryProvider)),
);

/// Notifier Provider
final transactionDetailNotifierProvider =
    StateNotifierProvider<TransactionDetailNotifier, TransactionDetailState>((
      ref,
    ) {
      final usecase = ref.read(getTransactionDetailUseCaseProvider);
      final deleteUseCase = ref.read(deleteTransactionUseCaseProvider);
      final updateUseCase = ref.read(updateTransactionUseCaseProvider);
      return TransactionDetailNotifier(usecase, deleteUseCase, updateUseCase, ref);
    });

//Trong riverPod: notifier: la class that, co bien state, ham fetchDetail de lay chi eite tu tuUsecase, onBack(). Day la noi de viet logic. Provider: (transactionDetailNotifierProvider) là cái nhãn để Riverpod biết muốn dùng norifier nyà tthì lấy ở đâu
