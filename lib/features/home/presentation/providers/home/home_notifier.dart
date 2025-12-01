// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/home/domain/usecases/get_lastest_suggestion.dart';
import 'package:fridge_to_fork_ai/features/home/domain/usecases/get_stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/home/domain/usecases/get_stats_overview.dart';
import 'package:fridge_to_fork_ai/features/home/domain/usecases/get_user_info.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart'
    show StatsByCategory;
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/suggestions.dart'
    show Suggestions;

/// State
class HomeState {
  final String userName;
  final StatsOverview? overview;
  final StatsByCategory? statsByCategory;
  final Suggestions? suggestion;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const HomeState({
    this.userName = '',
    this.overview,
    this.statsByCategory,
    this.suggestion,
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  HomeState copyWith({
    String? userName,
    StatsOverview? overview,
    StatsByCategory? statsByCategory,
    Suggestions? suggestion,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearSuggestion = false,
  }) {
    return HomeState(
      userName: userName ?? this.userName,
      overview: overview ?? this.overview,
      statsByCategory: statsByCategory ?? this.statsByCategory,
      suggestion: clearSuggestion ? null : (suggestion ?? this.suggestion),
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final GetStatsOverviewUseCase _getStatsOverview;
  final GetStatsByCategoryUseCase _getStatsByCategory;
  final GetLatestSuggestionUseCase _getLatestSuggestion;
  final GetUserInfo _getUserInfo;
  final Ref ref;

  HomeNotifier(
    this.ref,
    this._getStatsOverview,
    this._getStatsByCategory,
    this._getLatestSuggestion,
    this._getUserInfo,
  ) : super(const HomeState());

  /// INIT
  Future<void> init(BuildContext context) async {
    if (state.isLoading) return;
    await _loadData(context, showLoading: true);
  }

  /// REFRESH
  Future<void> onRefresh(BuildContext context) async {
    await _loadData(context, showLoading: false);
  }

  /// HANDLE LOAD ALL HOME DATA
  Future<void> _loadData(
    BuildContext context, {
    bool showLoading = true,
  }) async {
    try {
      state = state.copyWith(
        isLoading: showLoading,
        isRefreshing: !showLoading,
        errorMessage: null,
      );

      final overview = await _getStatsOverview();
      final stats = await _getStatsByCategory();
      final suggestion = await _getLatestSuggestion();
      final user = await _getUserInfo();

      state = state.copyWith(
        overview: overview,
        statsByCategory: stats,
        suggestion: suggestion,
        userName: user.name,
        isLoading: false,
        isRefreshing: false,
      );
    } catch (e) {
      _handleError(context, e);
    }
  }

  /// HANDLE ERROR
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
