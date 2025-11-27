import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budgets.dart';

/// State
class BudgetState {
  final List<Budget> budgets;
  final bool isLoading;
  final String? errorMessage;

  const BudgetState({
    this.budgets = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  BudgetState copyWith({
    List<Budget>? budgets,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BudgetState(
      budgets: budgets ?? this.budgets,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier
class BudgetNotifier extends StateNotifier<BudgetState> {
  final GetBudgetsUseCase _getBudgetsUseCase;

  BudgetNotifier(
    this._getBudgetsUseCase,
  ) : super(const BudgetState());

  Future<void> fetchBudgets() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final budgets = await _getBudgetsUseCase();
      state = state.copyWith(budgets: budgets, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}
