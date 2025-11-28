import 'package:equatable/equatable.dart';

class Budget extends Equatable {
  final String id;
  final String userId;
  final String categoryId;
  final String categoryName;
  final double amount;
  final double spentAmount;
  final String period; // monthly, weekly
  final int startDate;
  final int endDate;
  final double alertThreshold;
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

  @override
  List<Object?> get props => [
    id,
    userId,
    categoryId,
    categoryName,
    amount,
    spentAmount,
    period,
    startDate,
    endDate,
    alertThreshold,
    createdAt,
    updatedAt,
  ];

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['id'] as String,
      userId: json['userId'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String,
      amount: (json['amount'] as num).toDouble(),
      spentAmount: (json['spentAmount'] as num?)?.toDouble() ?? 0,
      period: json['period'] as String,
      startDate: json['startDate'] as int,
      endDate: json['endDate'] as int,
      alertThreshold: (json['alertThreshold'] as num).toDouble(),
      createdAt: json['createdAt'] as int,
      updatedAt: json['updatedAt'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
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

  Budget copyWith({
    double? spentAmount,
  }) {
    return Budget(
      id: id,
      userId: userId,
      categoryId: categoryId,
      categoryName: categoryName,
      amount: amount,
      spentAmount: spentAmount ?? this.spentAmount,
      period: period,
      startDate: startDate,
      endDate: endDate,
      alertThreshold: alertThreshold,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}
