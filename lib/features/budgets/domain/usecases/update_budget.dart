import 'package:finpal/features/budgets/domain/entities/update_budget_request.dart';
import 'package:finpal/features/budgets/domain/entities/budget.dart';
import 'package:finpal/features/budgets/domain/repositories/budget_repository.dart';

class UpdateBudgetUseCase {
  final BudgetRepository repository;

  UpdateBudgetUseCase(this.repository);

  Future<Budget> call(String budgetId, UpdateBudgetRequest request) async {
    return await repository.updateBudget(budgetId, request);
  }
}
