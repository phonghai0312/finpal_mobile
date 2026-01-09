import 'package:finpal/features/stats/domain/entities/stats_period.dart';

class StatsOverview {
  final StatsPeriod period;
  final String currency;
  final double totalExpense;
  final double totalIncome;
  final int totalTransactions;
  const StatsOverview({
    required this.period,
    required this.currency,
    required this.totalExpense,
    required this.totalIncome,
    required this.totalTransactions,
  });
}
