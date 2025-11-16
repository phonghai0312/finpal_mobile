import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';

import '../repositories/transaction_repository.dart';

class GetTransactionDetail {
  final TransactionRepository repository;

  GetTransactionDetail(this.repository);

  Future<Transaction> call(String id) async {
    return await repository.getTransactionDetail(id);
  }
}
