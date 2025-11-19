import 'package:fridge_to_fork_ai/features/transactions/domain/repositories/transaction_repository.dart';

class CreateTransaction {
  final TransactionRepository transactionRepository;
  CreateTransaction(this.transactionRepository);

  Future<void> call({
    required double amount,
    required String type, // income | expense
    required String categoryId,
    required String description,
    required int occurredAt, // timestamp
    String? note,
  }) async {
    await transactionRepository.createTransaction(
      amount: amount,
      type: type,
      categoryId: categoryId,
      description: description,
      occurredAt: occurredAt,
      note: note,
    );
  }
}
