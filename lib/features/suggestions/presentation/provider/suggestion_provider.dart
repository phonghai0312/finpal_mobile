import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/suggestions/data/datasources/insight_remote_data_source_impl.dart';
import 'package:fridge_to_fork_ai/features/suggestions/data/repositories/insight_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/get_insights.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/update_insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/usecases/get_insight_by_id.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/suggestions_notifier.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/suggestion_detail_notifier.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';

/// Data Source
final insightRemoteDataSourceProvider = Provider<InsightRemoteDataSourceImpl>(
  (ref) => InsightRemoteDataSourceImpl(),
);

/// Repository
final insightRepositoryProvider = Provider<InsightRepositoryImpl>(
  (ref) => InsightRepositoryImpl(
    remoteDataSource: ref.read(insightRemoteDataSourceProvider),
  ),
);

/// Use Cases
final getInsightsUseCaseProvider = Provider<GetInsightsUseCase>(
  (ref) => GetInsightsUseCase(ref.read(insightRepositoryProvider)),
);

final getInsightByIdUseCaseProvider = Provider<GetInsightByIdUseCase>(
  (ref) => GetInsightByIdUseCase(ref.read(insightRepositoryProvider)),
);

final updateInsightUseCaseProvider = Provider<UpdateInsightUseCase>(
  (ref) => UpdateInsightUseCase(ref.read(insightRepositoryProvider)),
);

/// Notifier Provider
final suggestionsNotifierProvider =
    StateNotifierProvider<SuggestionsNotifier, SuggestionsState>(
      (ref) => SuggestionsNotifier(
        ref.read(getInsightsUseCaseProvider),
        ref.read(updateInsightUseCaseProvider),
      ),
    );

final suggestionDetailNotifierProvider =
    StateNotifierProvider.family<
      SuggestionDetailNotifier,
      SuggestionDetailState,
      String
    >(
      (ref, insightId) => SuggestionDetailNotifier(
        ref.read(updateInsightUseCaseProvider),
        ref.read(getInsightByIdUseCaseProvider),
        insightId,
      ),
    );
