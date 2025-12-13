// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
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
    required this.month,
    required this.year,
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
  ) : super(StatsState(month: DateTime.now().month, year: DateTime.now().year));

  // ------------------------------
  // INIT
  // ------------------------------
  Future<void> init(BuildContext context) async {
    await loadStats(context);
  }

  // ------------------------------
  // LOAD DATA
  // ------------------------------
  Future<void> loadStats(BuildContext context) async {
    state = state.copyWith(isLoading: true, clearError: true);

    try {
      final (fromMs, toMs) = _monthRange(state.month, state.year);

      final overview = await _getStatsOverview(from: fromMs, to: toMs);
      final byCategory = await _getStatsByCategory(from: fromMs, to: toMs);

      state = state.copyWith(
        overview: overview,
        byCategory: byCategory,
        isLoading: false,
      );
    } catch (e) {
      _handleError(context, e);
    }
  }

  // ------------------------------
  // Refresh
  // ------------------------------
  Future<void> refresh(BuildContext context) async {
    state = state.copyWith(isRefreshing: true, clearError: true);

    try {
      await loadStats(context);
    } catch (e) {
      _handleError(context, e);
    }
  }

  // ------------------------------
  // Change month
  // ------------------------------
  Future<void> changeMonth(BuildContext context, int month, int year) async {
    state = state.copyWith(
      month: month,
      year: year,
      overview: null,
      byCategory: null,
    );

    await loadStats(context);
  }

  // ------------------------------
  // Get transactions for a category
  // ------------------------------
  Future<List<Transaction>> getTransactionsByCategory(String id) async {
    final (fromMs, toMs) = _monthRange(state.month, state.year);
    return _getCategoryTx(from: fromMs, to: toMs, categoryKey: id);
  }

  // ------------------------------
  // Clear error
  // ------------------------------
  void clearError() {
    state = state.copyWith(clearError: true);
  }

  // ------------------------------
  // Helper: Build month range (return MS)
  // ------------------------------
  (int, int) _monthRange(int month, int year) {
    final start = DateTime.utc(year, month, 1);
    final end = DateTime.utc(
      year,
      month + 1,
      1,
    ).subtract(const Duration(seconds: 1));

    return (
      start.millisecondsSinceEpoch, // MS UTC
      end.millisecondsSinceEpoch,
    );
  }

  /// ERROR handler
  void _handleError(BuildContext context, Object error) {
    String message = 'Unknown error';

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
      } else {
        message = error.message ?? message;
      }
    } else {
      message = error.toString();
    }

    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      errorMessage: message,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.typoError,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
