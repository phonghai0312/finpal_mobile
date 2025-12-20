class Budget {
  final String id;
  final String userId;

  final String categoryId;
  final String categoryName;

  final double amount;
  final double spentAmount;

  /// enum string: [monthly, weekly]
  final String period;

  /// Unix timestamp (ms)
  final int startDate;
  final int endDate;

  /// 0.8 = cảnh báo khi dùng 80%
  final double alertThreshold;

  /// Unix timestamp (ms)
  final int createdAt;
  final int updatedAt;

  const Budget({
    required this.id,
    required this.userId,
    required this.categoryId,
    required this.categoryName,
    required this.amount,
    this.spentAmount = 0,
    required this.period,
    required this.startDate,
    required this.endDate,
    required this.alertThreshold,
    required this.createdAt,
    required this.updatedAt,
  });

  Budget copyWith({
    double? amount,
    double? spentAmount,
    String? categoryId,
    String? categoryName,
    String? period,
    int? startDate,
    int? endDate,
    double? alertThreshold,
    int? updatedAt,
  }) {
    return Budget(
      id: id,
      userId: userId,
      categoryId: categoryId ?? this.categoryId,
      categoryName: categoryName ?? this.categoryName,
      amount: amount ?? this.amount,
      spentAmount: spentAmount ?? this.spentAmount,
      period: period ?? this.period,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      alertThreshold: alertThreshold ?? this.alertThreshold,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
