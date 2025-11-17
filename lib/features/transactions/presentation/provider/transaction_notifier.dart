import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

import '../../domain/entities/transaction.dart';
import '../../domain/usecase/get_transactions.dart';


class TransactionState {
  final List<Transaction> transactions;
  final bool isLoading;
  final String? errorMessage;
  final double totalIncome;
  final double totalExpense;

  const TransactionState({
    this.transactions = const [],
    this.isLoading = false,
    this.errorMessage,
    this.totalIncome = 0.0,
    this.totalExpense = 0.0,
  });

  TransactionState copyWith({
    List<Transaction>? transactions,
    bool? isLoading,
    String? errorMessage,
    double? totalIncome,
    double? totalExpense,
  }) {
    return TransactionState(
      transactions: transactions ?? this.transactions,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
    );
  }
}


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

  void onPress(BuildContext context)   {
    context.go(AppRoutes.createTransaction);
  }
}
