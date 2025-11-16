import 'package:fridge_to_fork_ai/features/home/data/models/stats_period_model.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart';
import 'stats_by_category_item_model.dart';

class StatsByCategoryModel extends StatsByCategory {
  const StatsByCategoryModel({
    required StatsPeriodModel super.period,
    required super.currency,
    required super.totalExpense,
    required List<StatsByCategoryItemModel> super.items,
  });

  factory StatsByCategoryModel.fromJson(Map<String, dynamic> json) {
    return StatsByCategoryModel(
      period: StatsPeriodModel.fromJson(json['period'] ?? {}),
      currency: json['currency'] ?? 'VND',
      totalExpense: (json['totalExpense'] ?? 0).toDouble(),
      items: (json['items'] as List<dynamic>? ?? [])
          .map((e) => StatsByCategoryItemModel.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'period': (period as StatsPeriodModel).toJson(),
    'currency': currency,
    'totalExpense': totalExpense,
    'items': items
        .map((e) => (e as StatsByCategoryItemModel).toJson())
        .toList(),
  };
}
