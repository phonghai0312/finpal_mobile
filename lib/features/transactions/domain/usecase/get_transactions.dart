import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactions {
  final TransactionRepository repository;

  GetTransactions(this.repository);

  Future<List<Transaction>> call({
    int? from,
    int? to,
    int? page,
    int? pageSize,
  }) {
    return repository.getTransactions(
      from: from,
      to: to,
      page: page,
      pageSize: pageSize,
    );
  }
}
