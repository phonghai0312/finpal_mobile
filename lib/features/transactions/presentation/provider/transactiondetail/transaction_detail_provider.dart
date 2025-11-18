import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/transaction_remote_datasources.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../domain/usecase/get_transaction_detail.dart';
import '../../../domain/usecase/delete_transaction.dart';
import 'transaction_detail_notifier.dart';

/// DATASOURCE (có thể tái dùng cái đang dùng cho list, nếu chung repo)
final transactionDetailRemoteDataSourceProvider =
Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSource(),
);

/// REPOSITORY
final transactionDetailRepositoryProvider =
Provider<TransactionRepositoryImpl>(
      (ref) => TransactionRepositoryImpl(
    ref.read(transactionDetailRemoteDataSourceProvider),
  ),
);

/// USECASES
final getTransactionDetailUsecaseProvider = Provider<GetTransactionDetail>(
      (ref) => GetTransactionDetail(
    ref.read(transactionDetailRepositoryProvider),
  ),
);

final deleteTransactionUsecaseProvider = Provider<DeleteTransaction>(
      (ref) => DeleteTransaction(
    ref.read(transactionDetailRepositoryProvider),
  ),
);

/// NOTIFIER
final transactionDetailNotifierProvider =
StateNotifierProvider<TransactionDetailNotifier, TransactionDetailState>(
      (ref) => TransactionDetailNotifier(
    ref.read(getTransactionDetailUsecaseProvider),
    ref.read(deleteTransactionUsecaseProvider),
    ref,
  ),
);
