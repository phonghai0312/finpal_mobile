import '../../domain/entities/transaction.dart';

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
