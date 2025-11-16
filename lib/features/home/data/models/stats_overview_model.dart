import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';

import 'stats_period_model.dart';

class StatsOverviewModel extends StatsOverview {
  const StatsOverviewModel({
    required StatsPeriodModel super.period,
    required super.currency,
    required super.totalExpense,
    required super.totalIncome,
    required super.totalTransactions,
  });

  factory StatsOverviewModel.fromJson(Map<String, dynamic> json) {
    return StatsOverviewModel(
      period: StatsPeriodModel.fromJson(json['period'] ?? {}),
      currency: json['currency'] ?? 'VND',
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      totalIncome: (json['totalIncome'] ?? 0).toDouble(),
      totalTransactions: json['totalTransactions'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    'period': (period as StatsPeriodModel).toJson(),
    'currency': currency,
    'totalExpense': totalExpense,
    'totalIncome': totalIncome,
    'totalTransactions': totalTransactions,
  };
}
