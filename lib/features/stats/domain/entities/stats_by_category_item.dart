import 'dart:ui';

class StatsByCategoryItem {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final double percentage;
  final Color color;

  const StatsByCategoryItem({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
    required this.color,
  });
}
