class StatsByCategoryItem {
  final String categoryId;
  final String categoryName;
  final double totalAmount;
  final double percentage;

  const StatsByCategoryItem({
    required this.categoryId,
    required this.categoryName,
    required this.totalAmount,
    required this.percentage,
  });
}
