import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/presentation/providers/month_filter_provider.dart';
import 'package:fridge_to_fork_ai/features/stats/data/datasources/stats_remote_datasource.dart';
import 'package:fridge_to_fork_ai/features/stats/data/repositories/stats_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/repositories/stats_repository.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_category_transactions.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/usecases/get_stats_overview.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';

import 'stats_notifier.dart';

final statsRemoteDataSourceProvider = Provider<StatsRemoteDataSource>((ref) {
  final transactionRemote = ref.read(transactionRemoteDataSourceProvider);
  return StatsRemoteDataSource(transactionRemote);
});

final statsRepositoryProvider = Provider<StatsRepository>((ref) {
  return StatsRepositoryImpl(ref.read(statsRemoteDataSourceProvider));
});

final getStatsOverviewUseCaseProvider = Provider<GetStatsOverview>((ref) {
  return GetStatsOverview(ref.read(statsRepositoryProvider));
});

final getStatsByCategoryUseCaseProvider = Provider<GetStatsByCategory>((ref) {
  return GetStatsByCategory(ref.read(statsRepositoryProvider));
});

final getCategoryTransactionsUseCaseProvider =
    Provider<GetCategoryTransactions>((ref) {
  return GetCategoryTransactions(ref.read(statsRepositoryProvider));
});

final statsNotifierProvider =
    StateNotifierProvider<StatsNotifier, StatsState>((ref) {
  final initialFilter = ref.read(monthFilterProvider);
  final notifier = StatsNotifier(
    initialFilter: initialFilter,
    getStatsOverview: ref.read(getStatsOverviewUseCaseProvider),
    getStatsByCategory: ref.read(getStatsByCategoryUseCaseProvider),
    getCategoryTransactions: ref.read(getCategoryTransactionsUseCaseProvider),
  );

  ref.listen<MonthFilterState>(monthFilterProvider, (prev, next) {
    if (prev != null &&
        (prev.month != next.month || prev.year != next.year)) {
      notifier.onMonthFilterChanged(next);
    }
  });

  return notifier;
});

