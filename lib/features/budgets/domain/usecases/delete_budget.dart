import 'package:finpal/features/budgets/domain/repositories/budget_repository.dart';

class DeleteBudgetUseCase {
  final BudgetRepository repository;

  DeleteBudgetUseCase(this.repository);

  Future<void> call(String budgetId) async {
    return await repository.deleteBudget(budgetId);
  }
}
