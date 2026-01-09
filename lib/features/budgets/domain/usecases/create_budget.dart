import 'package:finpal/features/budgets/domain/entities/create_budget_request.dart';
import 'package:finpal/features/budgets/domain/entities/budget.dart';
import 'package:finpal/features/budgets/domain/repositories/budget_repository.dart';

class CreateBudgetUseCase {
  final BudgetRepository repository;

  CreateBudgetUseCase(this.repository);

  Future<Budget> call(CreateBudgetRequest request) async {
    return await repository.createBudget(request);
  }
}
