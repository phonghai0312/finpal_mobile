import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';

class DeleteBudgetUseCase {
  final BudgetRepository repository;

  DeleteBudgetUseCase(this.repository);

  Future<void> call(String budgetId) async {
    return await repository.deleteBudget(budgetId);
  }
}
