import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import '../entities/stats_by_category.dart';
import '../entities/stats_overview.dart';

abstract class StatsRepository {
  Future<StatsOverview> getStatsOverview({required int from, required int to});
  Future<StatsByCategory> getStatsByCategory({
    required int from,
    required int to,
  });
  Future<List<Transaction>> getTransactionsByCategory({
    required int from,
    required int to,
    required String categoryKey,
  });
}
