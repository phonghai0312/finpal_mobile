import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';

class GetBudgetsUseCase {
  final BudgetRepository repository;

  GetBudgetsUseCase(this.repository);

  Future<List<Budget>> call({String? period, String? categoryId, int? page, int? pageSize}) async {
    return await repository.getBudgets(period: period, categoryId: categoryId, page: page, pageSize: pageSize);
  }
}
