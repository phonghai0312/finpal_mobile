import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';

class GetBudgetByIdUseCase {
  final BudgetRepository repository;

  GetBudgetByIdUseCase(this.repository);

  Future<Budget> call(String id) async {
    return await repository.getBudgetById(id);
  }
}
