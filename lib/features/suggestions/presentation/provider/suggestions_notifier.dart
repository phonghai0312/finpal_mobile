import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:equatable/equatable.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/get_insights.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/update_insight.dart';

class SuggestionsState extends Equatable {
  final List<Insight> insights;
  final bool isLoading;
  final String? error;

  const SuggestionsState({
    this.insights = const [],
    this.isLoading = false,
    this.error,
  });

  int get unreadCount => insights.where((insight) => !insight.read).length;

  SuggestionsState copyWith({
    List<Insight>? insights,
    bool? isLoading,
    String? error,
  }) {
    return SuggestionsState(
      insights: insights ?? this.insights,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [insights, isLoading, error];
}

class SuggestionsNotifier extends StateNotifier<SuggestionsState> {
  final GetInsightsUseCase getInsightsUseCase;
  final UpdateInsightUseCase updateInsightUseCase;

  SuggestionsNotifier(this.getInsightsUseCase, this.updateInsightUseCase)
    : super(const SuggestionsState());

  Future<void> fetchInsights() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final insights = await getInsightsUseCase.call();
      state = state.copyWith(insights: insights, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  Future<void> markInsightAsRead(String id) async {
    try {
      final updatedInsight = await updateInsightUseCase.call(id, true);
      state = state.copyWith(
        insights: state.insights
            .map((insight) => insight.id == id ? updatedInsight : insight)
            .toList(),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  int getUnreadInsightsCount() {
    return state.unreadCount;
  }
}
