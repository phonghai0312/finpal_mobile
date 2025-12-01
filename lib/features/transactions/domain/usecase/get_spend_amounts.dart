import '../entities/spend_amount.dart';
import '../repositories/transaction_repository.dart';

class GetSpendAmounts {
  final TransactionRepository repository;

  GetSpendAmounts(this.repository);

  Future<List<SpendAmount>> call({String? categoryId}) {
    return repository.getSpendAmounts(categoryId: categoryId);
  }
}


