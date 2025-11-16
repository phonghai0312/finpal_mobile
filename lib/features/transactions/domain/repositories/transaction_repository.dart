import '../../domain/entities/transaction.dart';
import '../../data/models/transaction_model.dart';

abstract class TransactionRepository {
  Future<TransactionListResponseModel> getTransactions({
    int? from,
    int? to,
    String? type,
    String? direction,
    String? categoryId,
    String? accountId,
    int page,
    int pageSize,
  });

  Future<Transaction> getTransactionDetail(String id);

  Future<void> updateTransaction({
    required String id,
    String? categoryId,
    String? userNote,
  });
}
