import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/update_budget_request.dart';
import 'package:uuid/uuid.dart';
class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  final List<Budget> _mockBudgets = [
    Budget(
      id: 'b001',
      userId: 'u001',
      categoryId: 'c001',
      categoryName: 'Ăn uống',
      amount: 2500000,
      period: 'monthly',
      startDate: 1672531200, // Jan 1, 2023
      endDate: 1675209599, // Jan 31, 2023
      alertThreshold: 80,
      createdAt: 1672531200,
      updatedAt: 1672531200,
    ),
    Budget(
      id: 'b002',
      userId: 'u001',
      categoryId: 'c002',
      categoryName: 'Mua sắm',
      amount: 4200000,
      period: 'monthly',
      startDate: 1672531200, // Jan 1, 2023
      endDate: 1675209599, // Jan 31, 2023
      alertThreshold: 70,
      createdAt: 1672531200,
      updatedAt: 1672531200,
    ),
    Budget(
      id: 'b003',
      userId: 'u001',
      categoryId: 'c003',
      categoryName: 'Đi lại',
      amount: 1000000,
      period: 'monthly',
      startDate: 1672531200, // Jan 1, 2023
      endDate: 1675209599, // Jan 31, 2023
      alertThreshold: 90,
      createdAt: 1672531200,
      updatedAt: 1672531200,
    ),
  ];

  @override
  Future<List<Budget>> getBudgets({
    String? period,
    String? categoryId,
    int? page,
    int? pageSize,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    List<Budget> filteredBudgets = _mockBudgets;

    if (period != null) {
      filteredBudgets = filteredBudgets
          .where((budget) => budget.period == period)
          .toList();
    }
    if (categoryId != null) {
      filteredBudgets = filteredBudgets
          .where((budget) => budget.categoryId == categoryId)
          .toList();
    }

    final int startIndex =
        ((page ?? 1) - 1) * (pageSize ?? filteredBudgets.length);
    final int endIndex = (startIndex + (pageSize ?? filteredBudgets.length))
        .clamp(0, filteredBudgets.length);

    return filteredBudgets.sublist(startIndex, endIndex);
  }

  Future<Budget> getBudgetById(String id) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      return _mockBudgets.firstWhere((budget) => budget.id == id);
    } catch (e) {
      throw Exception('Budget with ID $id not found.');
    }
  }

  @override
  Future<Budget> createBudget(CreateBudgetRequest request) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newBudget = Budget(
      id: const Uuid().v4(),
      userId: 'u001', // Mock user ID
      categoryId: request.categoryId,
      categoryName:
          'Mock Category Name', // TODO: Replace with actual category name lookup
      amount: request.amount,
      period: request.period,
      startDate: request.startDate,
      endDate: request.endDate,
      alertThreshold: request.alertThreshold ?? 80,
      createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
    );
    _mockBudgets.add(newBudget);
    return newBudget;
  }

  @override
  Future<Budget> updateBudget(
    String budgetId,
    UpdateBudgetRequest request,
  ) async {
    await Future.delayed(const Duration(milliseconds: 500));
    try {
      final index = _mockBudgets.indexWhere((budget) => budget.id == budgetId);
      if (index == -1) {
        throw Exception('Budget with ID $budgetId not found.');
      }
      final existingBudget = _mockBudgets[index];
      final updatedBudget = Budget(
        id: existingBudget.id,
        userId: existingBudget.userId,
        categoryId: request.categoryId ?? existingBudget.categoryId,
        categoryName: existingBudget.categoryName,
        amount: request.amount ?? existingBudget.amount,
        period: request.period ?? existingBudget.period,
        startDate: request.startDate ?? existingBudget.startDate,
        endDate: request.endDate ?? existingBudget.endDate      ,
        alertThreshold: request.alertThreshold ?? existingBudget.alertThreshold,
        createdAt: existingBudget.createdAt,
        updatedAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      _mockBudgets[index] = updatedBudget;
      return updatedBudget;
    } catch (e) {
      throw Exception('Failed to update budget: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    _mockBudgets.removeWhere((budget) => budget.id == budgetId);
    return Future.value();
  }
}
