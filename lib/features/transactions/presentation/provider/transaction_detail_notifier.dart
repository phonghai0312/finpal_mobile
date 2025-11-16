import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transaction_detail.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transactions.dart';

class TransactionDetailState {
  final bool isLoading;
  final Transaction? data;
  final String? error;

  const TransactionDetailState({
    this.isLoading = false,
    this.data,
    this.error,
  });

  TransactionDetailState copyWith({
    bool? isLoading,
    Transaction? data,
    String? error,
  }) {
    return TransactionDetailState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}



class TransactionDetailNotifier
    extends StateNotifier<TransactionDetailState> {
  final GetTransactionDetail getTransactionDetail;
  final String transactionId;

  TransactionDetailNotifier(this.getTransactionDetail, this.transactionId)
      : super(const TransactionDetailState()) {
    fetchDetail();
  }

  Future<void> fetchDetail() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tx = await getTransactionDetail(transactionId);
      state = state.copyWith(isLoading: false, data: tx);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }
}
