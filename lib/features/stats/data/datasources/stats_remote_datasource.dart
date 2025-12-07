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

  /// ============================
  /// 1) GET /stats/overview
  /// FE → gửi timestamps dạng seconds
  /// ============================
  Future<StatsOverviewModel> getStatsOverview({
    required int from,
    required int to,
  }) async {
    final fromSeconds = from ~/ 1000; // FE ms → BE seconds
    final toSeconds = to ~/ 1000;

    return _api.getStatsOverview(from: fromSeconds, to: toSeconds);
  }

  /// ============================
  /// 2) GET /stats/by-category
  /// FE → gửi timestamps dạng seconds
  /// ============================
  Future<StatsByCategoryModel> getStatsByCategory({
    required int from,
    required int to,
  }) async {
    final fromSeconds = from ~/ 1000;
    final toSeconds = to ~/ 1000;

    return _api.getStatsByCategory(from: fromSeconds, to: toSeconds);
  }

  /// ============================
  /// 3) Lấy transaction từ local cache API
  /// Filter theo milliseconds (FE toàn ms)
  /// ============================
  Future<List<TransactionModel>> getTransactionsByCategory({
    required int from,
    required int to,
    required String categoryKey,
  }) async {
    final all = await _transactionRemote.getTransactions();

    return all
        .where(
          (tx) =>
              tx.occurredAt >= from && // occurredAt = milliseconds
              tx.occurredAt <= to && // FE filter = milliseconds
              ((tx.categoryId ?? tx.categoryName ?? 'others') == categoryKey),
        )
        .toList();
  }
}
