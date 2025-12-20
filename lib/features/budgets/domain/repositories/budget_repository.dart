import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/update_budget_request.dart';

abstract class BudgetRepository {
  Future<List<Budget>> getBudgets({
    String? period,
    String? categoryId,
    int? page,
    int? pageSize,
  });
  Future<Budget> getBudgetById(String id);

  Future<Budget> createBudget(CreateBudgetRequest request);
  Future<Budget> updateBudget(String budgetId, UpdateBudgetRequest request);
  Future<void> deleteBudget(String budgetId);
}
