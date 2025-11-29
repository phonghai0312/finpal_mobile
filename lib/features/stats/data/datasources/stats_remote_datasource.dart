/// Stats Remote DataSource
/// Lấy dữ liệu thống kê từ backend theo swagger.yaml
library;

import 'package:fridge_to_fork_ai/features/stats/data/api/stats_api.dart';
import 'package:fridge_to_fork_ai/features/stats/data/models/stats_by_category_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_model.dart';

import '../models/stats_overview_model.dart';

class StatsRemoteDataSource {
  StatsRemoteDataSource(this._api, this._transactionRemote);

  final StatsApi _api;
  final TransactionRemoteDataSource _transactionRemote;

  Future<StatsOverviewModel> getStatsOverview({
    required int from,
    required int to,
  }) async {
    return _api.getStatsOverview(from: from, to: to);
  }

  Future<StatsByCategoryModel> getStatsByCategory({
    required int from,
    required int to,
  }) async {
    return _api.getStatsByCategory(from: from, to: to);
  }

  Future<List<TransactionModel>> getTransactionsByCategory({
    required int from,
    required int to,
    required String categoryKey,
  }) async {
    final all = await _transactionRemote.getTransactions();

    return all
        .where(
          (tx) =>
              tx.occurredAt >= from &&
              tx.occurredAt <= to &&
              ((tx.categoryId ?? tx.categoryName ?? 'others') == categoryKey),
        )
        .toList();
  }
}
