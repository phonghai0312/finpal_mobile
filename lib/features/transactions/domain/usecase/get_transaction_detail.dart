import '../repositories/transaction_repository.dart';
import '../entities/transaction.dart';

class GetTransactionDetailUseCase {
  final TransactionRepository repository;

  GetTransactionDetailUseCase(this.repository);

  Future<TransactionEntity> call(String id) async {
    return await repository.getTransactionDetail(id);
  }
}
