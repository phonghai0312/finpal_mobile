import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/usecase/get_transactions.dart';
import 'transaction_state.dart';

class TransactionNotifier extends StateNotifier<TransactionState> {
  final GetTransactions getTransactionsUseCase;

  TransactionNotifier(this.getTransactionsUseCase) : super(const TransactionState()) {
    fetchTransactions();
  }

  Future<void> fetchTransactions({
    int? from,
    int? to,
    String? type,
    String? direction,
    String? categoryId,
    String? accountId,
    int page = 1,
    int pageSize = 20,
  }) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final response = await getTransactionsUseCase.call(
        from: from,
        to: to,
        type: type,
        direction: direction,
        categoryId: categoryId,
        accountId: accountId,
        page: page,
        pageSize: pageSize,
      );
      double totalIncome = 0.0;
      double totalExpense = 0.0;

      for (var transaction in response.items) {
        if (transaction.type == 'income') {
          totalIncome += transaction.amount;
        } else if (transaction.type == 'expense') {
          totalExpense += transaction.amount;
        }
      }

      state = state.copyWith(
        transactions: response.items,
        isLoading: false,
        totalIncome: totalIncome,
        totalExpense: totalExpense,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
