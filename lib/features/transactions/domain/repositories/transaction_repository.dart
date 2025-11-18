import '../../domain/entities/transaction.dart';

abstract class TransactionRepository {
  Future<List<Transaction>> getTransactions();

  Future<Transaction> getTransactionDetail(String id);

  Future<void> updateTransaction({
    required String id,
    String? categoryId,
    String? userNote,
  });

  Future<void> createTransaction({
    required double amount,
    required String type, // income | expense
    required String categoryId,
    required String description,
    required int occurredAt, // unix timestamp
    String? note,
  });
}
