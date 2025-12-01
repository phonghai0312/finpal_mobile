import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';

class BudgetModel extends Budget {
  const BudgetModel({
    required super.id,
    required super.userId,
    required super.categoryId,
    required super.categoryName,
    required super.amount,
    super.spentAmount,
    required super.period,
    required super.startDate,
    required super.endDate,
    required super.alertThreshold,
    required super.createdAt,
    required super.updatedAt,
  });

  factory BudgetModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'] ?? json['id'] ?? json['budgetId'];
    final rawUser = json['user'] ?? json['userId'];
    return BudgetModel(
      id: rawId?.toString() ?? '',
      userId: rawUser?.toString() ?? '',
      categoryId: json['categoryId']?.toString() ?? '',
      categoryName: json['categoryName']?.toString() ?? '',
      amount: (json['amount'] as num?)?.toDouble() ?? 0,
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0,
      period: json['period']?.toString() ?? 'monthly',
      startDate: (json['startDate'] as num?)?.toInt() ?? 0,
      endDate: (json['endDate'] as num?)?.toInt() ?? 0,
      alertThreshold: (json['alertThreshold'] as num?)?.toDouble() ?? 80,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'categoryId': categoryId,
      'categoryName': categoryName,
      'amount': amount,
      'spentAmount': spentAmount,
      'period': period,
      'startDate': startDate,
      'endDate': endDate,
      'alertThreshold': alertThreshold,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  Budget toEntity() {
    return Budget(
      id: id,
      userId: userId,
      categoryId: categoryId,
      categoryName: categoryName,
      amount: amount,
      spentAmount: spentAmount,
      period: period,
      startDate: startDate,
      endDate: endDate,
      alertThreshold: alertThreshold,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class BudgetListResponseModel {
  final List<BudgetModel> items;
  final int page;
  final int pageSize;
  final int total;

  const BudgetListResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory BudgetListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>?) ?? const <dynamic>[];
    return BudgetListResponseModel(
      items: rawItems
          .map((item) => BudgetModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? rawItems.length,
      total: (json['total'] as num?)?.toInt() ?? rawItems.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((item) => item.toJson()).toList(),
      'page': page,
      'pageSize': pageSize,
      'total': total,
    };
  }
}
