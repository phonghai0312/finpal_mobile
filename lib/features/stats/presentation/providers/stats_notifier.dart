import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/presentation/providers/month_filter_provider.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_category_transactions.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_overview.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';

class StatsState {
  final StatsOverview? overview;
  final StatsByCategory? byCategory;
  final bool isLoading;
  final bool isRefreshing;
  final int selectedMonth;
  final int selectedYear;
  final DateTime periodStart;
  final String? errorMessage;

  const StatsState({
    this.overview,
    this.byCategory,
    this.isLoading = false,
    this.isRefreshing = false,
    required this.selectedMonth,
    required this.selectedYear,
    required this.periodStart,
    this.errorMessage,
  });

  factory StatsState.initial(MonthFilterState filter) {
    return StatsState(
      selectedMonth: filter.month,
      selectedYear: filter.year,
      periodStart: filter.start,
    );
  }

  StatsState copyWith({
    StatsOverview? overview,
    StatsByCategory? byCategory,
    bool? isLoading,
    bool? isRefreshing,
    int? selectedMonth,
    int? selectedYear,
    DateTime? periodStart,
    String? errorMessage,
    bool clearOverview = false,
    bool clearByCategory = false,
    bool clearError = false,
  }) {
    return StatsState(
      overview: clearOverview ? null : (overview ?? this.overview),
      byCategory: clearByCategory ? null : (byCategory ?? this.byCategory),
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      selectedMonth: selectedMonth ?? this.selectedMonth,
      selectedYear: selectedYear ?? this.selectedYear,
      periodStart: periodStart ?? this.periodStart,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }

  bool get hasData => overview != null && byCategory != null;
}

class StatsNotifier extends StateNotifier<StatsState> {
  final GetStatsOverview _getStatsOverview;
  final GetStatsByCategory _getStatsByCategory;
  final GetCategoryTransactions _getCategoryTransactions;

  StatsNotifier({
    required MonthFilterState initialFilter,
    required GetStatsOverview getStatsOverview,
    required GetStatsByCategory getStatsByCategory,
    required GetCategoryTransactions getCategoryTransactions,
  })  : _getStatsOverview = getStatsOverview,
        _getStatsByCategory = getStatsByCategory,
        _getCategoryTransactions = getCategoryTransactions,
        super(StatsState.initial(initialFilter));

  Future<void> init() async {
    if (state.isLoading || state.hasData) return;
    await _loadData(showLoading: true);
  }

  Future<void> refresh() => _loadData(showLoading: false);

  void clearError() {
    if (state.errorMessage != null) {
      state = state.copyWith(clearError: true);
    }
  }

  Future<void> onMonthFilterChanged(MonthFilterState filter) async {
    if (filter.month == state.selectedMonth &&
        filter.year == state.selectedYear) {
      return;
    }

    state = state.copyWith(
      selectedMonth: filter.month,
      selectedYear: filter.year,
      periodStart: filter.start,
      clearOverview: true,
      clearByCategory: true,
    );

    await _loadData(showLoading: true);
  }

  Future<List<Transaction>> getTransactionsByCategory(
    String categoryKey,
  ) async {
    final range = _buildMonthlyRange(state.periodStart);
    return _getCategoryTransactions(
      from: range.$1,
      to: range.$2,
      categoryKey: categoryKey,
    );
  }

  Future<void> _loadData({required bool showLoading}) async {
    try {
      state = state.copyWith(
        isLoading: showLoading,
        isRefreshing: !showLoading,
        errorMessage: null,
      );

      final range = _buildMonthlyRange(state.periodStart);

      final overview = await _getStatsOverview(from: range.$1, to: range.$2);
      final byCategory =
          await _getStatsByCategory(from: range.$1, to: range.$2);

      state = state.copyWith(
        overview: overview,
        byCategory: byCategory,
        isLoading: false,
        isRefreshing: false,
      );
    } catch (error, stackTrace) {
      debugPrint('StatsNotifier error: $error\n$stackTrace');
      state = state.copyWith(
        isLoading: false,
        isRefreshing: false,
        errorMessage: error.toString(),
      );
    }
  }

  (int, int) _buildMonthlyRange(DateTime start) {
    final nextMonth = DateTime(start.year, start.month + 1, 1);
    final end = nextMonth.subtract(const Duration(minutes: 1));
    return (_toSeconds(start), _toSeconds(end));
  }

  int _toSeconds(DateTime dateTime) =>
      dateTime.toUtc().millisecondsSinceEpoch ~/ 1000;
}

