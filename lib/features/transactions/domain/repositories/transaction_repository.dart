import '../../domain/entities/transaction.dart';
import '../../data/models/transaction_model.dart';
import '../../data/models/transaction_update_request_model.dart';

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

  Future<Transaction> updateTransaction(
    String id,
    TransactionUpdateRequestModel request,
  );
}
