import '../../data/models/transaction_model.dart';
import '../../data/models/transaction_update_request_model.dart';

abstract class TransactionRemoteDataSource {
  Future<TransactionListResponseModel> getTransactions({
    int? from,
    int? to,
    String? type,
    String? direction,
    String? categoryId,
    String? accountId,
    int page = 1,
    int pageSize = 20,
  });

  Future<TransactionModel> getTransactionDetail(String id);

  Future<TransactionModel> updateTransaction(
    String id,
    TransactionUpdateRequestModel request,
  );
}
