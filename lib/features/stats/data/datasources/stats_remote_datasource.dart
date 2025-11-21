/// Stats Remote DataSource (Mock)
/// Lấy dữ liệu từ TransactionRemoteDataSource để đồng bộ với trang giao dịch
library;

import 'package:flutter/material.dart';
import 'package:fridge_to_fork_ai/features/stats/data/models/stats_by_category_item_model.dart';
import 'package:fridge_to_fork_ai/features/stats/data/models/stats_by_category_model.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_period.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_model.dart';

import '../models/stats_overview_model.dart';

class StatsRemoteDataSource {
  StatsRemoteDataSource(this._transactionRemote);

  final TransactionRemoteDataSource _transactionRemote;

  static const Map<String, Color> _categoryColorPresets = {
    'c001': Colors.orange,
    'c002': Colors.purple,
    'c003': Colors.green,
    'c004': Colors.blue,
    'c005': Colors.red,
    'c006': Colors.amber,
    'c007': Colors.teal,
  };

  static const List<Color> _fallbackPalette = [
    Colors.deepPurple,
    Colors.cyan,
    Colors.indigo,
    Colors.pink,
    Colors.lime,
    Colors.brown,
    Colors.deepOrange,
  ];

  Future<StatsOverviewModel> getStatsOverview({
    required int from,
    required int to,
  }) async {
    final filtered = await _getTransactionsInRange(from, to);
    final incomeTotal = _sumAmount(filtered, 'income');
    final expenseTotal = _sumAmount(filtered, 'expense');

    final currency = filtered.isNotEmpty ? filtered.first.currency : 'VND';

    return StatsOverviewModel(
      period: StatsPeriod(from: from, to: to),
      currency: currency,
      totalExpense: expenseTotal,
      totalIncome: incomeTotal,
      totalTransactions: filtered.length,
    );
  }

  Future<StatsByCategoryModel> getStatsByCategory({
    required int from,
    required int to,
  }) async {
    final filtered = await _getTransactionsInRange(from, to);
    final expenseTransactions = filtered
        .where((tx) => tx.type == 'expense')
        .toList();

    final totalExpense = expenseTransactions.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );

    final grouped = <String, _CategoryAggregate>{};
    for (final tx in expenseTransactions) {
      final key = tx.categoryId ?? tx.categoryName ?? 'others';
      grouped.putIfAbsent(
        key,
        () => _CategoryAggregate(
          id: key,
          name: tx.categoryName ?? 'Khác',
          color: _resolveColor(key, grouped.length),
          amount: 0,
        ),
      );
      grouped[key] = grouped[key]!.copyWith(
        amount: grouped[key]!.amount + tx.amount,
      );
    }

    final sorted = grouped.values.toList()
      ..sort((a, b) => b.amount.compareTo(a.amount));

    final items = sorted.map((agg) {
      final percentage = totalExpense == 0 ? 0.0 : agg.amount / totalExpense;
      return StatsByCategoryItemModel(
        categoryId: agg.id,
        categoryName: agg.name,
        totalAmount: agg.amount,
        percentage: percentage,
      );
    }).toList();

    final currency = filtered.isNotEmpty ? filtered.first.currency : 'VND';

    return StatsByCategoryModel(
      period: StatsPeriod(from: from, to: to),
      currency: currency,
      totalExpense: totalExpense,
      items: items,
    );
  }

  Future<List<TransactionModel>> getTransactionsByCategory({
    required int from,
    required int to,
    required String categoryKey,
  }) async {
    final filtered = await _getTransactionsInRange(from, to);
    return filtered.where((tx) => _categoryKey(tx) == categoryKey).toList();
  }

  Future<List<TransactionModel>> _getTransactionsInRange(
    int from,
    int to,
  ) async {
    final list = await _transactionRemote.getTransactions();
    return list
        .where((tx) => tx.occurredAt >= from && tx.occurredAt <= to)
        .toList();
  }

  double _sumAmount(List<TransactionModel> list, String type) {
    return list
        .where((tx) => tx.type == type)
        .fold<double>(0, (sum, tx) => sum + tx.amount);
  }

  Color _resolveColor(String key, int index) {
    return _categoryColorPresets[key] ??
        _fallbackPalette[index % _fallbackPalette.length];
  }

  String _categoryKey(TransactionModel tx) =>
      tx.categoryId ?? tx.categoryName ?? 'others';
}

class _CategoryAggregate {
  final String id;
  final String name;
  final Color color;
  final double amount;

  const _CategoryAggregate({
    required this.id,
    required this.name,
    required this.color,
    required this.amount,
  });

  _CategoryAggregate copyWith({double? amount}) {
    return _CategoryAggregate(
      id: id,
      name: name,
      color: color,
      amount: amount ?? this.amount,
    );
  }
}
