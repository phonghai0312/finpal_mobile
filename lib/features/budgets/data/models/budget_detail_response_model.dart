import 'package:fridge_to_fork_ai/features/budgets/data/models/budget_model.dart';

class BudgetDetailResponse {
  final BudgetModel budget;

  BudgetDetailResponse({required this.budget});

  factory BudgetDetailResponse.fromJson(Map<String, dynamic> json) {
    final raw = json['data'] ?? json['budget'] ?? json;

    if (raw is! Map<String, dynamic>) {
      throw Exception('Invalid budget response');
    }

    return BudgetDetailResponse(budget: BudgetModel.fromJson(raw));
  }
}
