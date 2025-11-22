import 'package:fridge_to_fork_ai/features/budgets/data/models/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';

class CreateBudgetUseCase {
  final BudgetRepository repository;

  CreateBudgetUseCase(this.repository);

  Future<Budget> call(CreateBudgetRequest request) async {
    return await repository.createBudget(request);
  }
}
