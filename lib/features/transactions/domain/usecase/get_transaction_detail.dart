import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class GetTransactionDetail {
  final TransactionRepository repository;

  GetTransactionDetail(this.repository);

  Future<Transaction> call(String id) async {
    return await repository.getTransactionDetail(id);
  }
}
