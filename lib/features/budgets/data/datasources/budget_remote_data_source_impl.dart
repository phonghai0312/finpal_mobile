import 'package:dio/dio.dart';
import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/api/budget_api.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/create_budget_request.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/update_budget_request.dart';

class BudgetRemoteDataSourceImpl implements BudgetRemoteDataSource {
  BudgetRemoteDataSourceImpl({BudgetApi? api, ApiClient? client})
      : _api = api ?? (client ?? ApiClient()).create(BudgetApi.new);

  final BudgetApi _api;

  @override
  Future<List<Budget>> getBudgets({
    String? period,
    String? categoryId,
    int? page,
    int? pageSize,
  }) async {
    final response = await _guardRequest(
      () => _api.getBudgets(
        period: period,
        categoryId: categoryId,
        page: page,
        pageSize: pageSize,
      ),
    );
    return response.items.map((model) => model.toEntity()).toList();
  }

  @override
  Future<Budget> getBudgetById(String id) async {
    final model = await _guardRequest(() => _api.getBudgetById(id));
    return model.toEntity();
  }

  @override
  Future<Budget> createBudget(CreateBudgetRequest request) async {
    final body = request.toJson();
    final model = await _guardRequest(() => _api.createBudget(body));
    return model.toEntity();
  }

  @override
  Future<Budget> updateBudget(
    String budgetId,
    UpdateBudgetRequest request,
  ) async {
    final body = request.toJson();
    final model = await _guardRequest(() => _api.updateBudget(budgetId, body));
    return model.toEntity();
  }

  @override
  Future<void> deleteBudget(String budgetId) async {
    await _guardRequest(() => _api.deleteBudget(budgetId));
  }

  Future<T> _guardRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (dioError) {
      final dynamic data = dioError.response?.data;
      final message = (data is Map && data['message'] is String)
          ? data['message'] as String
          : dioError.message;
      throw Exception(message ?? 'Unexpected server error');
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
