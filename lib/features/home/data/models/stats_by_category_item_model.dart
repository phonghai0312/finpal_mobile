import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category_item.dart';

class StatsByCategoryItemModel extends StatsByCategoryItem {
  const StatsByCategoryItemModel({
    required super.categoryId,
    required super.categoryName,
    required super.totalAmount,
    required super.percentage,
  });

  factory StatsByCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return StatsByCategoryItemModel(
      categoryId: json['categoryId'] ?? '',
      categoryName: json['categoryName'] ?? '',
      totalAmount: (json['totalAmount'] ?? 0).toDouble(),
      percentage: (json['percentage'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'totalAmount': totalAmount,
    'percentage': percentage,
  };
}
