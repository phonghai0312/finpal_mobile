import '../../domain/entities/stats_overview.dart';
import '../../domain/entities/stats_period.dart';

class StatsOverviewModel extends StatsOverview {
  const StatsOverviewModel({
    required super.period,
    required super.currency,
    required super.totalExpense,
    required super.totalIncome,
    required super.totalTransactions,
  });

  factory StatsOverviewModel.fromJson(Map<String, dynamic> json) {
    final periodJson = json['period'] as Map<String, dynamic>?;

    return StatsOverviewModel(
      period: StatsPeriod(
        from: ((periodJson?['from'] ?? json['from']) as int) * 1000,
        to: ((periodJson?['to'] ?? json['to']) as int) * 1000,
      ),
      currency: json['currency'] as String? ?? 'VND',
      totalExpense: (json['totalExpense'] as num).toDouble(),
      totalIncome: (json['totalIncome'] as num).toDouble(),
      totalTransactions: json['totalTransactions'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
    'period': {'from': period.from, 'to': period.to},
    'currency': currency,
    'totalExpense': totalExpense,
    'totalIncome': totalIncome,
    'totalTransactions': totalTransactions,
  };
}
