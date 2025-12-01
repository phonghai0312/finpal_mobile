import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/update_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/create_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/update_budget.dart';

enum BudgetPeriod { monthly, weekly }

/// State
class BudgetFormState {
  final Budget? budget;
  final bool isLoading;
  final String? errorMessage;
  final bool isSuccess;
  final BudgetPeriod period;
  final int? startDate;
  final int? endDate;
  final String? categoryId;
  final String? categoryName;

  const BudgetFormState({
    this.budget,
    this.isLoading = false,
    this.errorMessage,
    this.isSuccess = false,
    this.period = BudgetPeriod.monthly,
    this.startDate,
    this.endDate,
    this.categoryId,
    this.categoryName,
  });

  BudgetFormState copyWith({
    Budget? budget,
    bool? isLoading,
    String? errorMessage,
    bool? isSuccess,
    BudgetPeriod? period,
    int? startDate,
    int? endDate,
    bool clearBudget = false,
    String? categoryId,
    String? categoryName,
    bool clearCategory = false,
  }) {
    return BudgetFormState(
      budget: clearBudget ? null : (budget ?? this.budget),
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
      isSuccess: isSuccess ?? this.isSuccess,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      categoryId: clearCategory ? null : (categoryId ?? this.categoryId),
      categoryName:
          clearCategory ? null : (categoryName ?? this.categoryName),
    );
  }
}

/// Notifier
class BudgetFormNotifier extends StateNotifier<BudgetFormState> {
  final CreateBudgetUseCase _createBudgetUseCase;
  final UpdateBudgetUseCase _updateBudgetUseCase;
  final GetBudgetByIdUseCase _getBudgetByIdUseCase;

  BudgetFormNotifier(
    this._createBudgetUseCase,
    this._updateBudgetUseCase,
    this._getBudgetByIdUseCase,
  ) : super(const BudgetFormState());

  void setPeriod(BudgetPeriod period) {
    state = state.copyWith(period: period);
  }

  void setStartDate(int startDate) {
    state = state.copyWith(startDate: startDate);
  }

  void setEndDate(int endDate) {
    state = state.copyWith(endDate: endDate);
  }

  Future<void> loadBudget(String budgetId) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final budget = await _getBudgetByIdUseCase(budgetId);
      state = state.copyWith(
        budget: budget,
        isLoading: false,
        period: budget.period == 'monthly'
            ? BudgetPeriod.monthly
            : BudgetPeriod.weekly,
        startDate: budget.startDate,
        endDate: budget.endDate,
        categoryId: budget.categoryId,
        categoryName: budget.categoryName,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  void setCategory({
    required String id,
    required String name,
  }) {
    state = state.copyWith(categoryId: id, categoryName: name);
  }

  Future<void> createBudget({
    required double amount,
    required double alertThreshold,
  }) async {
    if (state.categoryId == null) {
      state = state.copyWith(errorMessage: 'Vui lòng chọn danh mục');
      return;
    }
    if (state.startDate == null || state.endDate == null) {
      state = state.copyWith(
        errorMessage: 'Vui lòng chọn khoảng thời gian phù hợp',
      );
      return;
    }
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final request = CreateBudgetRequest(
        categoryId: state.categoryId!,
        amount: amount,
        period: state.period.name, // Use the selected period
        startDate: state.startDate!,
        endDate: state.endDate!,
        alertThreshold: alertThreshold,
      );
      await _createBudgetUseCase(request);
      state = state.copyWith(
        isLoading: false,
        isSuccess: true,
        clearBudget: true,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }

  Future<void> updateBudget({
    required String budgetId,
    double? amount,
    double? alertThreshold,
  }) async {
    final categoryId = state.categoryId ?? state.budget?.categoryId;
    if (categoryId == null) {
      state = state.copyWith(errorMessage: 'Vui lòng chọn danh mục');
      return;
    }
    state = state.copyWith(
      isLoading: true,
      errorMessage: null,
      isSuccess: false,
    );
    try {
      final request = UpdateBudgetRequest(
        categoryId: categoryId,
        amount: amount,
        period: state.period.name,
        startDate: state.startDate,
        endDate: state.endDate,
        alertThreshold: alertThreshold,
      );
      await _updateBudgetUseCase(budgetId, request);
      state = state.copyWith(isLoading: false, isSuccess: true);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: e.toString(),
        isSuccess: false,
      );
    }
  }
}
