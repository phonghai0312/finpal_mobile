import '../../domain/repositories/transaction_repository.dart';
import '../datasources/transaction_remote_datasources.dart';
import '../models/transaction_model.dart';
import '../models/transaction_update_request_model.dart';
import '../../domain/entities/transaction.dart';

class TransactionRepositoryImpl implements TransactionRepository {
  final TransactionRemoteDataSource remoteDataSource;

  TransactionRepositoryImpl({required this.remoteDataSource});

  @override
  Future<TransactionListResponseModel> getTransactions({
    int? from,
    int? to,
    String? type,
    String? direction,
    String? categoryId,
    String? accountId,
    int page = 1,
    int pageSize = 20,
  }) async {
    return await remoteDataSource.getTransactions(
      from: from,
      to: to,
      type: type,
      direction: direction,
      categoryId: categoryId,
      accountId: accountId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Transaction> getTransactionDetail(String id) async {
    final model = await remoteDataSource.getTransactionDetail(id);
    return model;
  }

  @override
  Future<void> updateTransaction({
    required String id,
    String? categoryId,
    String? userNote,
  }) async {
    final request = TransactionUpdateRequestModel(
      categoryId: categoryId,
      userNote: userNote,
    );
    await remoteDataSource.updateTransaction(id, request);
  }
}
