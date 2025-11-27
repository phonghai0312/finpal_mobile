import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/delete_transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transaction_detail.dart'
    show GetTransactionDetail;
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/update_transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transactiondetail/transaction_detail_notifier.dart';

// final transactionDetailRemoteDataSourceProvider =
//     Provider<TransactionRemoteDataSource>(
//       (ref) => TransactionRemoteDataSource(),
//     );

final transactionDetailRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) =>
      TransactionRepositoryImpl(ref.read(transactionRemoteDataSourceProvider)),
);

final getTransactionDetailUsecaseProvider = Provider<GetTransactionDetail>(
  (ref) => GetTransactionDetail(ref.read(transactionDetailRepositoryProvider)),
);

final deleteTransactionUsecaseProvider = Provider<DeleteTransaction>(
  (ref) => DeleteTransaction(ref.read(transactionDetailRepositoryProvider)),
);
final updateTransactionUsecaseProvider = Provider<UpdateTransaction>(
  (ref) => UpdateTransaction(ref.read(transactionDetailRepositoryProvider)),
);
final transactionDetailNotifierProvider =
    StateNotifierProvider<TransactionDetailNotifier, TransactionDetailState>(
      (ref) => TransactionDetailNotifier(
        ref.read(getTransactionDetailUsecaseProvider),
        ref.read(deleteTransactionUsecaseProvider),
        ref.read(updateTransactionUsecaseProvider),
        ref,
      ),
    );
