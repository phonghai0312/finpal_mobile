import '../../data/models/transaction_update_request_model.dart';
import '../entities/transaction.dart';
import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<Transaction> call(
    String id,
    TransactionUpdateRequestModel request,
  ) async {
    return await repository.updateTransaction(id, request);
  }
}
