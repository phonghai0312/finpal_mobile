import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/delete_budget.dart';
import 'package:go_router/go_router.dart';

/// State
class BudgetDetailState {
  final Budget? budget;
  final bool isLoading;
  final String? errorMessage;

  const BudgetDetailState({
    this.budget,
    this.isLoading = false,
    this.errorMessage,
  });

  BudgetDetailState copyWith({
    Budget? budget,
    bool? isLoading,
    String? errorMessage,
  }) {
    return BudgetDetailState(
      budget: budget ?? this.budget,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier
class BudgetDetailNotifier extends StateNotifier<BudgetDetailState> {
  final GetBudgetByIdUseCase _getBudgetByIdUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final String _budgetId;

  BudgetDetailNotifier(
    this._budgetId,
    this._getBudgetByIdUseCase,
    this._deleteBudgetUseCase,
  ) : super(const BudgetDetailState()) {
    _fetchBudget();
  }

  Future<void> _fetchBudget() async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final budget = await _getBudgetByIdUseCase(_budgetId);
      state = state.copyWith(budget: budget, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void goToEdit(BuildContext context) {
    if (state.budget == null) return;
    context.push(AppRoutes.budgetForm, extra: _budgetId);
  }

  Future<void> deleteBudget(BuildContext context) async {
    final targetId = state.budget?.id ?? _budgetId;
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      await _deleteBudgetUseCase(targetId);
      state = state.copyWith(
        budget: null,
        isLoading: false,
        errorMessage: null,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Ngân sách đã được xóa thành công!'),
          backgroundColor: Colors.green,
        ),
      );
      context.pop();
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
