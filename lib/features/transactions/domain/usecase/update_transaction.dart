import '../repositories/transaction_repository.dart';

class UpdateTransaction {
  final TransactionRepository repository;

  UpdateTransaction(this.repository);

  Future<void> call({required String id, String? categoryId, String? userNote, String? merchant}) async {
    await repository.updateTransaction(id: id, categoryId: categoryId, userNote: userNote, merchant: merchant);
  }
}
