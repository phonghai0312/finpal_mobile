import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/delete_budget.dart';
import 'package:go_router/go_router.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';

/// State
class BudgetDetailState {
  final Budget? budget;
  final bool isLoading;
  final String? errorMessage;
  final String? budgetId;

  const BudgetDetailState({
    this.budget,
    this.isLoading = false,
    this.errorMessage,
    this.budgetId,
  });

  BudgetDetailState copyWith({
    Budget? budget,
    bool? isLoading,
    String? errorMessage,
    String? budgetId,
  }) {
    return BudgetDetailState(
      budget: budget ?? this.budget,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      budgetId: budgetId ?? this.budgetId,
    );
  }
}

/// Notifier
class BudgetDetailNotifier extends StateNotifier<BudgetDetailState> {
  final GetBudgetByIdUseCase _getBudgetByIdUseCase;
  final DeleteBudgetUseCase _deleteBudgetUseCase;
  final Ref _ref;

  BudgetDetailNotifier(
    this._getBudgetByIdUseCase,
    this._deleteBudgetUseCase,
    this._ref,
  ) : super(const BudgetDetailState()) {
    // Watch selectedBudgetIdProvider và tự động fetch khi id thay đổi
    _ref.listen<String?>(selectedBudgetIdProvider, (previous, next) {
      if (next != null && next.isNotEmpty && next != previous) {
        _fetchBudget(next);
      }
    });
    
    // Fetch ngay nếu đã có id
    final currentId = _ref.read(selectedBudgetIdProvider);
    if (currentId != null && currentId.isNotEmpty) {
      _fetchBudget(currentId);
    }
  }

  Future<void> _fetchBudget(String budgetId) async {
    state = state.copyWith(isLoading: true, errorMessage: null, budgetId: budgetId);
    try {
      final budget = await _getBudgetByIdUseCase(budgetId);
      state = state.copyWith(budget: budget, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void goToEdit(BuildContext context) {
    if (state.budget == null || state.budgetId == null) return;
    context.push(AppRoutes.budgetForm, extra: state.budgetId);
  }

  Future<void> deleteBudget(BuildContext context) async {
    final targetId = state.budget?.id ?? state.budgetId ?? '';
    if (targetId.isEmpty) return;
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
