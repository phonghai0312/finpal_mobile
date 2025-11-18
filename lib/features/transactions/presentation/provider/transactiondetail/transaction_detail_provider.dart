import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transactiondetail/transaction_detail_notifier.dart';

import '../../../data/datasources/transaction_remote_datasources.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../domain/usecase/get_transaction_detail.dart';

/// ============================
/// DataSource Provider
/// ============================
final transactionDetailRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSource(),
    );

/// ============================
/// Repository Provider
/// ============================
final transactionDetailRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) => TransactionRepositoryImpl(
    ref.read(transactionDetailRemoteDataSourceProvider),
  ),
);

/// ============================
/// UseCase Provider
/// ============================
final getTransactionDetailProvider = Provider<GetTransactionDetail>(
  (ref) => GetTransactionDetail(ref.read(transactionDetailRepositoryProvider)),
);

/// ============================
/// Notifier Provider
/// ============================
final transactionDetailNotifierProvider =
    StateNotifierProvider<TransactionDetailNotifier, TransactionDetailState>(
      (ref) => TransactionDetailNotifier(
        ref.read(getTransactionDetailProvider),
        ref,
      ),
    );
