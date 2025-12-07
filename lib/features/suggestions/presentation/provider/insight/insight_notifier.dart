// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../domain/entities/insight.dart';
import '../../../domain/usecases/get_insights.dart';

/// ============================
/// STATE
/// ============================
class InsightsState {
  final List<Insight> insights;
  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  /// Insight được chọn để xem chi tiết (không dùng ID nữa)
  final Insight? selectedInsight;

  const InsightsState({
    this.insights = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
    this.selectedInsight,
  });

  InsightsState copyWith({
    List<Insight>? insights,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    Insight? selectedInsight,
  }) {
    return InsightsState(
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
      selectedInsight: selectedInsight ?? this.selectedInsight,
    );
  }
}

/// ============================
/// NOTIFIER
/// ============================
class InsightsNotifier extends StateNotifier<InsightsState> {
  final GetInsightsUseCase _getInsights;
  final Ref ref;

  InsightsNotifier(this._getInsights, this.ref) : super(const InsightsState());

  /// INIT khi mở màn hình
  Future<void> init(BuildContext context) async {
    await fetchInsights(context);
  }

  /// FETCH API
  Future<void> fetchInsights(BuildContext context) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    try {
      final list = await _getInsights();
      state = state.copyWith(insights: list, isLoading: false);
    } catch (e) {
      _handleError(context, e);
    }
  }

  /// REFRESH
  Future<void> refresh(BuildContext context) async {
    state = state.copyWith(isRefreshing: true, errorMessage: null);

    try {
      final list = await _getInsights();
      state = state.copyWith(insights: list, isRefreshing: false);
    } catch (e) {
      _handleError(context, e);
    }
  }

  /// ============================
  /// USER TAP → Xem chi tiết Insight
  /// ============================
  void onTapDetail(BuildContext context, Insight insight) {
    state = state.copyWith(selectedInsight: insight);

    // Điều hướng giống booking
    context.go(AppRoutes.suggestionDetail);
  }

  /// ============================
  /// ERROR handler
  /// ============================
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
