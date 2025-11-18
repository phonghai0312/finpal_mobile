import 'package:fridge_to_fork_ai/features/transactions/domain/repositories/transaction_repository.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_creation_request_model.dart';

class CreateTransactionUseCase {
  final TransactionRepository repository;

  CreateTransactionUseCase(this.repository);

  Future<void> call({required TransactionCreationRequestModel transaction}) async {
    await repository.createTransaction(transaction);
  }
}
