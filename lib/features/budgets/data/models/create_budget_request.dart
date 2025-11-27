import 'package:equatable/equatable.dart';

class CreateBudgetRequest extends Equatable {
  final String categoryId;
  final double amount;
  final String period;
  final int startDate;
  final int endDate;
  final double? alertThreshold;

  const CreateBudgetRequest({
    required this.categoryId,
    required this.amount,
    required this.period,
    required this.startDate,
    required this.endDate,
    this.alertThreshold,
  });

  Map<String, dynamic> toJson() {
    return {
      'categoryId': categoryId,
      'amount': amount,
      'period': period,
      'startDate': startDate,
      'endDate': endDate,
      'alertThreshold': alertThreshold,
    };
  }

  @override
  List<Object?> get props => [
    categoryId,
    amount,
    period,
    startDate,
    endDate,
    alertThreshold,
  ];
}
