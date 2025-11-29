import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/stats/data/api/stats_api.dart';
import 'package:fridge_to_fork_ai/features/stats/data/datasources/stats_remote_datasource.dart';
import 'package:fridge_to_fork_ai/features/stats/data/repositories/stats_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_category_transactions.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_overview.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';

import 'stats_notifier.dart';

/// ===============================
/// API PROVIDER
/// ===============================
final statsApiProvider = Provider<StatsApi>(
  (ref) => ApiClient().create(StatsApi.new),
);

/// ===============================
/// DATASOURCE PROVIDER
/// ===============================
final statsRemoteDataSourceProvider = Provider<StatsRemoteDataSource>((ref) {
  return StatsRemoteDataSource(
    ref.read(statsApiProvider),
    ref.read(transactionRemoteDataSourceProvider),
  );
});

/// ===============================
/// REPOSITORY PROVIDER
/// ===============================
final statsRepositoryProvider = Provider<StatsRepositoryImpl>((ref) {
  return StatsRepositoryImpl(ref.read(statsRemoteDataSourceProvider));
});

/// ===============================
/// USECASE PROVIDERS
/// ===============================
final getStatsOverviewProvider = Provider<GetStatsOverview>((ref) {
  return GetStatsOverview(ref.read(statsRepositoryProvider));
});

final getStatsByCategoryProvider = Provider<GetStatsByCategory>((ref) {
  return GetStatsByCategory(ref.read(statsRepositoryProvider));
});

final getCategoryTransactionsProvider = Provider<GetCategoryTransactions>((
  ref,
) {
  return GetCategoryTransactions(ref.read(statsRepositoryProvider));
});

/// ===============================
/// NOTIFIER PROVIDER
/// ===============================
final statsNotifierProvider = StateNotifierProvider<StatsNotifier, StatsState>((
  ref,
) {
  return StatsNotifier(
    ref.read(getStatsOverviewProvider),
    ref.read(getStatsByCategoryProvider),
    ref.read(getCategoryTransactionsProvider),
  );
});
