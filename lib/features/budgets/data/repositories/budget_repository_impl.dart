import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/budget_model.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/update_budget_request.dart';

class BudgetRepositoryImpl implements BudgetRepository {
  final BudgetRemoteDataSource remoteDataSource;

  BudgetRepositoryImpl({required this.remoteDataSource});

  /// =======================
  /// GET BUDGETS
  /// =======================
  @override
  Future<List<Budget>> getBudgets({
    String? period,
    String? categoryId,
    int? page,
    int? pageSize,
  }) async {
    final response = await remoteDataSource.getBudgets(
      period: period,
      categoryId: categoryId,
      page: page,
      pageSize: pageSize,
    );

    return response.items
        .map<Budget>((BudgetModel model) => model.toEntity())
        .toList();
  }

  /// =======================
  /// GET BUDGET BY ID
  /// =======================
  @override
  Future<Budget> getBudgetById(String id) async {
    final model = await remoteDataSource.getBudgetById(id);
    return model.toEntity();
  }

  /// =======================
  /// CREATE BUDGET
  /// =======================
  @override
  Future<Budget> createBudget(CreateBudgetRequest request) async {
    final model = await remoteDataSource.createBudget(
      categoryId: request.categoryId,
      amount: request.amount,
      period: request.period,
      startDate: request.startDate,
      endDate: request.endDate,
      alertThreshold: request.alertThreshold,
    );

    return model.toEntity();
  }

  /// =======================
  /// UPDATE BUDGET
  /// =======================
  @override
  Future<Budget> updateBudget(
    String budgetId,
    UpdateBudgetRequest request,
  ) async {
    final model = await remoteDataSource.updateBudget(
      categoryId: request.categoryId,
      id: budgetId,
      amount: request.amount,
      period: request.period,
      startDate: request.startDate,
      endDate: request.endDate,
      alertThreshold: request.alertThreshold,
    );

    return model.toEntity();
  }

  /// =======================
  /// DELETE BUDGET
  /// =======================
  @override
  Future<void> deleteBudget(String budgetId) {
    return remoteDataSource.deleteBudget(budgetId);
  }
}
