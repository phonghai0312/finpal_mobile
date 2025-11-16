import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/usecase/get_transaction_detail.dart';
import '../../../domain/usecase/update_transaction.dart';
import '../../../data/repositories/transaction_repository_impl.dart';

final getTransactionDetailUseCaseProvider = Provider<GetTransactionDetailUseCase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return GetTransactionDetailUseCase(repository);
});

final updateTransactionUseCaseProvider = Provider<UpdateTransactionUseCase>((ref) {
  final repository = ref.read(transactionRepositoryProvider);
  return UpdateTransactionUseCase(repository);
});

class TransactionDetailNotifier extends StateNotifier<AsyncValue<TransactionEntity>> {
  final GetTransactionDetailUseCase _getTransactionDetail;
  final UpdateTransactionUseCase _updateTransactionUseCase;

  TransactionDetailNotifier(this._getTransactionDetail, this._updateTransactionUseCase) : super(const AsyncValue.loading());

  Future<void> fetchTransaction(String id) async {
    state = const AsyncValue.loading();
    try {
      final transaction = await _getTransactionDetail.call(id);
      state = AsyncValue.data(transaction);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> updateTransaction({required String id, String? categoryId, String? userNote}) async {
    state = const AsyncValue.loading();
    try {
      await _updateTransactionUseCase.call(id: id, categoryId: categoryId, userNote: userNote);
      // After update, refetch the transaction to ensure UI is up-to-date
      await fetchTransaction(id);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final transactionDetailNotifierProvider = StateNotifierProvider.family<TransactionDetailNotifier, AsyncValue<TransactionEntity>, String>((ref, id) {
  final getTransactionDetailUseCase = ref.watch(getTransactionDetailUseCaseProvider);
  final updateTransactionUseCase = ref.watch(updateTransactionUseCaseProvider);
  return TransactionDetailNotifier(getTransactionDetailUseCase, updateTransactionUseCase);
});
