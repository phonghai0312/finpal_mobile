// ignore_for_file: curly_braces_in_flow_control_structures

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/update_insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/get_insight_by_id.dart';

class SuggestionDetailState extends Equatable {
  final Insight? insight;
  final bool isLoading;
  final String? error;

  const SuggestionDetailState({
    this.insight,
    this.isLoading = false,
    this.error,
  });

  SuggestionDetailState copyWith({
    Insight? insight,
    bool? isLoading,
    String? error,
  }) {
    return SuggestionDetailState(
      insight: insight ?? this.insight,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [insight, isLoading, error];
}

class SuggestionDetailNotifier extends StateNotifier<SuggestionDetailState> {
  final UpdateInsightUseCase updateInsightUseCase;
  final GetInsightByIdUseCase getInsightByIdUseCase;
  final String insightId;

  SuggestionDetailNotifier(
    this.updateInsightUseCase,
    this.getInsightByIdUseCase,
    this.insightId,
  ) : super(const SuggestionDetailState()) {
    _fetchInsight();
  }

  Future<void> _fetchInsight() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final insight = await getInsightByIdUseCase.call(insightId);
      state = state.copyWith(insight: insight, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markAsRead() async {
    if (state.insight == null)
      return; // Cannot mark as read if insight is not loaded

    state = state.copyWith(isLoading: true, error: null);
    try {
      final updatedInsight = await updateInsightUseCase.call(
        state.insight!.id,
        true,
      );
      state = state.copyWith(insight: updatedInsight, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }
}
