import '../../data/models/transaction_model.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<TransactionListResponseModel> call({
    int? from,
    int? to,
    String? type,
    String? direction,
    String? categoryId,
    String? accountId,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await repository.getTransactions(
      from: from,
      to: to,
      type: type,
      direction: direction,
      categoryId: categoryId,
      accountId: accountId,
      page: page,
      pageSize: pageSize,
    );
  }
}
