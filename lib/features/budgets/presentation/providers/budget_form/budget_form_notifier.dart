// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';

import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/update_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/create_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/update_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget/budget_provider.dart';
import 'package:go_router/go_router.dart';

enum BudgetPeriod { monthly, weekly }

enum BudgetFormMode { create, edit }

/// ===============================
/// STATE
/// ===============================
class BudgetFormState {
  final BudgetFormMode mode;

  final bool isLoading;
  final String? error;

  final Budget? budget;

  final BudgetPeriod period;
  final int? startDate;
  final int? endDate;
  final String? categoryId;
  final String? categoryName;

  const BudgetFormState({
    this.mode = BudgetFormMode.create,
    this.isLoading = false,
    this.error,
    this.budget,
    this.period = BudgetPeriod.monthly,
    this.startDate,
    this.endDate,
    this.categoryId,
    this.categoryName,
  });

  bool get isEditMode => mode == BudgetFormMode.edit;

  BudgetFormState copyWith({
    BudgetFormMode? mode,
    bool? isLoading,
    String? error,
    Budget? budget,
    bool clearBudget = false,
    BudgetPeriod? period,
    int? startDate,
    int? endDate,
    String? categoryId,
    String? categoryName,
  }) {
    return BudgetFormState(
      mode: mode ?? this.mode,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      budget: clearBudget ? null : (budget ?? this.budget),
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
    );
  }
}

/// ===============================
/// NOTIFIER (COMMAND STYLE – giống CreateTransaction)
/// ===============================
class BudgetFormNotifier extends StateNotifier<BudgetFormState> {
  final CreateBudgetUseCase _createBudget;
  final UpdateBudgetUseCase _updateBudget;
  final GetBudgetByIdUseCase _getBudgetById;
  final Ref ref;

  BudgetFormNotifier(
    this._createBudget,
    this._updateBudget,
    this._getBudgetById,
    this.ref,
  ) : super(const BudgetFormState());

  /// ===============================
  /// ENTER CREATE MODE
  /// ===============================
  void enterCreateMode() {
    state = const BudgetFormState(mode: BudgetFormMode.create);
  }

  /// ===============================
  /// ENTER EDIT MODE (LOAD DATA)
  /// ===============================
  Future<void> enterEditMode(String budgetId) async {
    state = const BudgetFormState(mode: BudgetFormMode.edit, isLoading: true);

    try {
      final budget = await _getBudgetById(budgetId);

      state = state.copyWith(
        isLoading: false,
        budget: budget,
        period: budget.period == 'weekly'
            ? BudgetPeriod.weekly
            : BudgetPeriod.monthly,
        startDate: budget.startDate,
        endDate: budget.endDate,
        categoryId: budget.categoryId,
        categoryName: budget.categoryName,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  /// ===============================
  /// SETTERS (UI)
  /// ===============================
  void setPeriod(BudgetPeriod value) {
    state = state.copyWith(period: value);
  }

  void setStartDate(int value) {
    state = state.copyWith(startDate: value);
  }

  void setEndDate(int value) {
    state = state.copyWith(endDate: value);
  }

  void setCategory({required String id, required String name}) {
    state = state.copyWith(categoryId: id, categoryName: name);
  }

  /// ===============================
  /// SUBMIT (CREATE / UPDATE)
  /// ===============================
  Future<void> submit(
    BuildContext context, {
    required double amount,
    required double alertThreshold,
  }) async {
    if (state.categoryId == null) {
      _showError(context, 'Vui lòng chọn danh mục');
      return;
    }

    if (state.startDate == null || state.endDate == null) {
      _showError(context, 'Vui lòng chọn khoảng thời gian');
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      if (state.isEditMode) {
        await _updateBudget(
          state.budget!.id,
          UpdateBudgetRequest(
            categoryId: state.categoryId!,
            amount: amount,
            period: state.period.name,
            startDate: state.startDate,
            endDate: state.endDate,
            alertThreshold: alertThreshold,
          ),
        );
      } else {
        await _createBudget(
          CreateBudgetRequest(
            categoryId: state.categoryId!,
            amount: amount,
            period: state.period.name,
            startDate: state.startDate!,
            endDate: state.endDate!,
            alertThreshold: alertThreshold,
          ),
        );
      }

      await ref.read(budgetNotifierProvider.notifier).refresh(context);

      // 🔥 RESET VỀ CREATE MODE SAU KHI XONG
      enterCreateMode();

      context.go(AppRoutes.home);
    } catch (e) {
      _showError(context, e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  void _showError(BuildContext context, String msg) {
    state = state.copyWith(error: msg);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void onBack(BuildContext context) {
    enterCreateMode();
    context.go(AppRoutes.home);
  }
}
