import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/spend_amount.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/repositories/transaction_repository.dart'
    show TransactionRepository;

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remote;

  TransactionRepositoryImpl(this.remote);

  @override
  Future<List<Transaction>> getTransactions() async {
    final list = await remote.getTransactions();
    return list.map((m) => m.toEntity()).toList();
  }

  @override
  Future<Transaction> getTransactionDetail(String id) async {
    final model = await remote.getTransactionDetail(id);
    return model.toEntity();
  }

  @override
  Future<void> updateTransaction({
    required String id,
    String? categoryId,
    String? userNote,
    String? merchant,
  }) async {
    await remote.updateTransaction(
      id,
      categoryId: categoryId,
      userNote: userNote,
      merchant: merchant,
    );
  }

  @override
  Future<void> deleteTransaction(String id) async {
    await remote.deleteTransaction(id);
  }

  @override
  Future<Transaction> createTransaction({
    required double amount,
    required String type,
    required String categoryId,
    required String description,
    required int occurredAt,
    String? note,
  }) async {
    final model = await remote.createTransaction(
      amount: amount,
      type: type,
      categoryId: categoryId,
      description: description,
      occurredAt: occurredAt,
      note: note,
    );

    return model.toEntity();
  }

  @override
  Future<List<SpendAmount>> getSpendAmounts({String? categoryId}) async {
    final response = await remote.getSpendAmounts(categoryId: categoryId);
    return response
        .map(
          (model) => SpendAmount(
            categoryId: model.categoryId,
            categoryName: model.categoryName,
            spentAmount: model.spentAmount,
          ),
        )
        .toList();
  }
}
