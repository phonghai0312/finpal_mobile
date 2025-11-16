import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category_item.dart'
    show StatsByCategoryItem;
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_period.dart';

class StatsByCategory {
  final StatsPeriod period;
  final String currency;
  final double totalExpense;
  final List<StatsByCategoryItem> items;

  const StatsByCategory({
    required this.period,
    required this.currency,
    required this.totalExpense,
    required this.items,
  });
}
