import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_category_transactions.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_overview.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';

class StatsState {
  final bool isLoading;
  final bool isRefreshing;

  final StatsOverview? overview;
  final StatsByCategory? byCategory;

  final int month;
  final int year;

  final String? errorMessage;

  const StatsState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.overview,
    this.byCategory,
    this.month = 1,
    this.year = 2025,
    this.errorMessage,
  });

  StatsState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    StatsOverview? overview,
    StatsByCategory? byCategory,
    int? month,
    int? year,
    String? errorMessage,
    bool clearError = false,
  }) {
    return StatsState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      overview: overview ?? this.overview,
      byCategory: byCategory ?? this.byCategory,
      month: month ?? this.month,
      year: year ?? this.year,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class StatsNotifier extends StateNotifier<StatsState> {
  final GetStatsOverview _getStatsOverview;
  final GetStatsByCategory _getStatsByCategory;
  final GetCategoryTransactions _getCategoryTx;

  StatsNotifier(
    this._getStatsOverview,
    this._getStatsByCategory,
    this._getCategoryTx,
  ) : super(const StatsState());

  // ------------------------------
  // INIT
  // ------------------------------
  Future<void> init() async {
    await loadStats();
  }

  // ------------------------------
  // LOAD DATA
  // ------------------------------
  Future<void> loadStats() async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final (from, to) = _monthRange(state.month, state.year);

      final overview = await _getStatsOverview(from: from, to: to);
      final byCategory = await _getStatsByCategory(from: from, to: to);

      state = state.copyWith(
        overview: overview,
        byCategory: byCategory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }

  // ------------------------------
  // Refresh
  // ------------------------------
  Future<void> refresh() async {
    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      await loadStats();
    } catch (_) {}

    state = state.copyWith(isRefreshing: false);
  }

  // ------------------------------
  // Change month
  // ------------------------------
  Future<void> changeMonth(int month, int year) async {
    state = state.copyWith(
      month: month,
      year: year,
      overview: null,
      byCategory: null,
    );

    await loadStats();
  }

  // ------------------------------
  // Get transactions for a category
  // ------------------------------
  Future<List<Transaction>> getTransactionsByCategory(String id) async {
    final (from, to) = _monthRange(state.month, state.year);
    return _getCategoryTx(from: from, to: to, categoryKey: id);
  }

  // ------------------------------
  // Clear error
  // ------------------------------
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // ------------------------------
  // Helper: Build month range
  // ------------------------------
  (int, int) _monthRange(int month, int year) {
    final start = DateTime(year, month, 1);
    final end = DateTime(
      year,
      month + 1,
      1,
    ).subtract(const Duration(seconds: 1));

    return (
      start.toUtc().millisecondsSinceEpoch ~/ 1000,
      end.toUtc().millisecondsSinceEpoch ~/ 1000,
    );
  }
}
