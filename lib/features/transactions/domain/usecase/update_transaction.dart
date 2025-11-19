import '../repositories/transaction_repository.dart';

class UpdateTransactionUseCase {
  final TransactionRepository repository;

  UpdateTransactionUseCase(this.repository);

  Future<void> call({required String id, String? categoryId, String? userNote}) async {
    await repository.updateTransaction(id: id, categoryId: categoryId, userNote: userNote);
  }
}
