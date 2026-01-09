// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:finpal/features/budgets/presentation/providers/budget_form/budget_form_provider.dart';
import 'package:go_router/go_router.dart';

import 'package:finpal/core/config/routing/app_routes.dart';
import 'package:finpal/features/budgets/domain/entities/budget.dart';
import 'package:finpal/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:finpal/features/budgets/domain/usecases/delete_budget.dart';
import 'package:finpal/features/budgets/presentation/providers/budget/budget_provider.dart';

/// ===============================
/// STATE
/// ===============================
class BudgetDetailState {
  final bool isLoading;
  final String? error;
  final Budget? data;

  const BudgetDetailState({this.isLoading = false, this.error, this.data});

  BudgetDetailState copyWith({bool? isLoading, String? error, Budget? data}) {
    return BudgetDetailState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

/// ===============================
/// NOTIFIER
/// ===============================
class BudgetDetailNotifier extends StateNotifier<BudgetDetailState> {
  final GetBudgetByIdUseCase _getBudgetById;
  final DeleteBudgetUseCase _deleteBudget;
  final Ref ref;

  /// 🔒 ID ĐƯỢC ĐÓNG BĂNG – DÙNG DUY NHẤT
  String? _detailBudgetId;

  BudgetDetailNotifier(this._getBudgetById, this._deleteBudget, this.ref)
    : super(const BudgetDetailState());

  // -----------------------------
  // INIT (LOAD DETAIL)
  // -----------------------------
  Future<void> init() async {
    final selectedId = ref
        .read(budgetNotifierProvider.notifier)
        .selectedBudgetId;

    if (selectedId == null) {
      state = state.copyWith(error: 'Không tìm thấy ID ngân sách');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);

      final budget = await _getBudgetById(selectedId);

      /// 🔥 ĐÓNG BĂNG ID NGAY SAU KHI LOAD
      _detailBudgetId = budget.id;

      state = state.copyWith(isLoading: false, data: budget);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // -----------------------------
  // BACK
  // -----------------------------
  void onBack(BuildContext context) {
    context.go(AppRoutes.home);
  }

  // -----------------------------
  // DELETE
  // -----------------------------
  Future<void> onDelete(BuildContext context) async {
    if (state.isLoading) return;

    final id = _detailBudgetId;
    if (id == null) {
      _showError(context, 'Không xác định được ngân sách cần xoá');
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      await _deleteBudget(id);

      /// ✅ REFRESH LIST BUDGET
      await ref.read(budgetNotifierProvider.notifier).refresh(context);

      if (!context.mounted) return;
      context.go(AppRoutes.home);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Đã xoá ngân sách')));
    } catch (e) {
      _showError(context, e.toString());
    } finally {
      state = state.copyWith(isLoading: false);
    }
  }

  // -----------------------------
  // RESET (KHI RỜI PAGE)
  // -----------------------------
  void reset() {
    _detailBudgetId = null;
    state = const BudgetDetailState();
  }

  void _showError(BuildContext context, String msg) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void onEdit(BuildContext context) {
    final budget = state.data;
    if (budget == null) return;

    ref.read(budgetFormNotifierProvider.notifier).enterEditMode(budget.id);
    context.go(AppRoutes.budgetForm);
  }
}
