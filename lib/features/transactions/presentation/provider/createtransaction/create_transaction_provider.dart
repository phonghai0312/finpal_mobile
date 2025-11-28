import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../data/datasources/transaction_remote_datasources.dart';
import '../../../data/repositories/transaction_repository_impl.dart';
import '../../../domain/usecase/create_transaction.dart';
import '../transaction/transaction_provider.dart' show transactionApiProvider;
import 'create_transaction_notifier.dart';

/// ===============================
/// DATASOURCE PROVIDER
/// ===============================
final createTransactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) => TransactionRemoteDataSource(
        api: ref.read(transactionApiProvider),
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
      (ref) =>
      CreateTransactionNotifier(ref.read(createTransactionUsecaseProvider)),
);
