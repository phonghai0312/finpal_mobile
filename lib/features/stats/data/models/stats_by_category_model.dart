import '../../domain/entities/stats_by_category.dart';
import '../../domain/entities/stats_period.dart';
import 'stats_by_category_item_model.dart';

class StatsByCategoryModel extends StatsByCategory {
  const StatsByCategoryModel({
    required super.period,
    required super.currency,
    required super.totalExpense,
    required super.items,
  });

  factory StatsByCategoryModel.fromJson(Map<String, dynamic> json) {
    final itemsList = (json['items'] as List<dynamic>? ?? [])
        .map(
          (item) =>
              StatsByCategoryItemModel.fromJson(item as Map<String, dynamic>),
        )
        .toList();

    return StatsByCategoryModel(
      period: StatsPeriod(
        from: json['from'] as int,
        to: json['to'] as int,
      ),
      currency: json['currency'] as String? ?? 'VND',
      totalExpense: (json['totalExpense'] as num).toDouble(),
      items: itemsList,
    );
  }

  Map<String, dynamic> toJson() => {
        'from': period.from,
        'to': period.to,
        'currency': currency,
        'totalExpense': totalExpense,
        'items': items
            .map((item) => (item as StatsByCategoryItemModel).toJson())
            .toList(),
      };
}
