/// Stats By Category Item Model
/// Dùng cho JSON parsing từ API
library;

import '../../domain/entities/stats_by_category_item.dart';

class StatsByCategoryItemModel extends StatsByCategoryItem {
  const StatsByCategoryItemModel({
    required super.categoryId,
    required super.categoryName,
    required super.totalAmount,
    required super.percentage,
  });

  factory StatsByCategoryItemModel.fromJson(Map<String, dynamic> json) {
    return StatsByCategoryItemModel(
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      totalAmount: (json['totalAmount'] as num).toDouble(),
      percentage: (json['percentage'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() => {
    'categoryId': categoryId,
    'categoryName': categoryName,
    'totalAmount': totalAmount,
    'percentage': percentage,
  };
}
