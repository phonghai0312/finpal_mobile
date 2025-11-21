/// Stats Repository Implementation
/// Dùng khi có backend - hiện tại mock data
library;

import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';

import '../../domain/entities/stats_by_category.dart';
import '../../domain/entities/stats_overview.dart';
import '../../domain/repositories/stats_repository.dart';
import '../datasources/stats_remote_datasource.dart';

class StatsRepositoryImpl implements StatsRepository {
  final StatsRemoteDataSource remote;

  StatsRepositoryImpl(this.remote);

  @override
  Future<StatsOverview> getStatsOverview({required int from, required int to}) {
    return remote.getStatsOverview(from: from, to: to);
  }

  @override
  Future<StatsByCategory> getStatsByCategory({
    required int from,
    required int to,
  }) {
    return remote.getStatsByCategory(from: from, to: to);
  }

  @override
  Future<List<Transaction>> getTransactionsByCategory({
    required int from,
    required int to,
    required String categoryKey,
  }) async {
    final models = await remote.getTransactionsByCategory(
      from: from,
      to: to,
      categoryKey: categoryKey,
    );
    return models.map((m) => m.toEntity()).toList();
  }
}
