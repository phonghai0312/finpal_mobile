import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/insight/insight_notifier.dart';

import '../../../../../core/network/api_client.dart';
import '../../../data/api/insight_api.dart';
import '../../../data/datasources/insight_remote_data_source.dart';
import '../../../data/repositories/insight_repository_impl.dart';
import '../../../domain/usecases/get_insights.dart';

/// API Provider
final insightsApiProvider = Provider<InsightApi>((ref) {
  return ApiClient().create(InsightApi.new);
});

/// Remote DataSource Provider
final insightsRemoteDataSourceProvider = Provider<InsightRemoteDataSource>((
  ref,
) {
  return InsightRemoteDataSource(ref.read(insightsApiProvider));
});

/// Repository Provider
final insightsRepositoryProvider = Provider<InsightRepositoryImpl>((ref) {
  return InsightRepositoryImpl(ref.read(insightsRemoteDataSourceProvider));
});

/// UseCase Provider
final getInsightsUseCaseProvider = Provider<GetInsightsUseCase>((ref) {
  return GetInsightsUseCase(ref.read(insightsRepositoryProvider));
});

/// Notifier Provider
final insightsNotifierProvider =
    StateNotifierProvider<InsightsNotifier, InsightsState>((ref) {
      return InsightsNotifier(ref.read(getInsightsUseCaseProvider), ref);
    });
