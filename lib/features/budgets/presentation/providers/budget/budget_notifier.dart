// ignore_for_file: unused_result, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_detail/budget_detail_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budgets.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_spend_amounts.dart';

/// ===============================
/// STATE
/// ===============================
class BudgetState {
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;
  final List<Budget> budgets;

  const BudgetState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.budgets = const [],
  });

  BudgetState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    List<Budget>? budgets,
  }) {
    return BudgetState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
      budgets: budgets ?? this.budgets,
    );
  }
}

/// ===============================
/// NOTIFIER
/// ===============================
class BudgetNotifier extends StateNotifier<BudgetState> {
  final GetBudgetsUseCase _getBudgets;
  final GetSpendAmounts _getSpendAmounts;
  final Ref ref;

  /// budget được chọn để xem detail
  String? _selectedBudgetId;
  String? get selectedBudgetId => _selectedBudgetId;

  BudgetNotifier(this._getBudgets, this._getSpendAmounts, this.ref)
    : super(const BudgetState());

  /// ============================================
  /// INIT PAGE
  /// ============================================
  Future<void> init(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final budgets = await _loadBudgetsWithSpend();
      state = state.copyWith(isLoading: false, budgets: budgets);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// ============================================
  /// REFRESH
  /// ============================================
  Future<void> refresh(BuildContext context) async {
    state = state.copyWith(isRefreshing: true);

    try {
      final budgets = await _loadBudgetsWithSpend();
      state = state.copyWith(isRefreshing: false, budgets: budgets);
    } catch (e) {
      state = state.copyWith(isRefreshing: false);
      _showError(context, e.toString());
    }
  }

  /// ============================================
  /// CORE LOGIC
  /// ============================================
  Future<List<Budget>> _loadBudgetsWithSpend() async {
    final budgets = await _getBudgets();
    final spendAmounts = await _getSpendAmounts();

    final spendMap = {
      for (final item in spendAmounts) item.categoryId: item.spentAmount,
    };

    return budgets
        .map(
          (b) =>
              b.copyWith(spentAmount: spendMap[b.categoryId] ?? b.spentAmount),
        )
        .toList();
  }

  /// ============================================
  /// CLICK ITEM → DETAIL
  /// (GIỐNG HỆT TransactionNotifier)
  /// ============================================
  void onBudgetSelected(BuildContext context, Budget budget) {
    _selectedBudgetId = budget.id;

    // Reset lại detail notifier
    ref.refresh(budgetDetailNotifierProvider);

    context.go(AppRoutes.budgetDetail);
  }

  /// ============================================
  /// ERROR HANDLER
  /// ============================================
  void _showError(BuildContext context, String msg) {
    state = state.copyWith(errorMessage: msg);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void clearSelectedBudget() {
    _selectedBudgetId = null;
  }

  void setSelectedBudget(String id) {
    _selectedBudgetId = id;
  }
}
