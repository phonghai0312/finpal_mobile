import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/update_budget_request.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Budget>> getBudgets({
    String? period,
    String? categoryId,
    int? page,
    int? pageSize,
  }) {
    return remoteDataSource.getBudgets(
      period: period,
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );
  }

  @override
  Future<Budget> getBudgetById(String id) {
    return remoteDataSource.getBudgetById(id);
  }

  @override
  Future<Budget> createBudget(CreateBudgetRequest request) {
    return remoteDataSource.createBudget(request);
  }

  @override
  Future<Budget> updateBudget(String budgetId, UpdateBudgetRequest request) {
    return remoteDataSource.updateBudget(budgetId, request);
  }

  @override
  Future<void> deleteBudget(String budgetId) {
    return remoteDataSource.deleteBudget(budgetId);
  }
}
