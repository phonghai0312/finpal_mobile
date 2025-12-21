import 'package:dio/dio.dart';

import '../api/budget_api.dart';
import '../models/budget_model.dart';

class BudgetRemoteDataSource {
  final BudgetApi api;

  BudgetRemoteDataSource(this.api);

  /// =======================
  /// GET BUDGETS (LIST)
  /// =======================
  Future<BudgetListResponseModel> getBudgets({
    String? period,
    String? categoryId,
    int? page,
    int? pageSize,
  }) {
    return _guardRequest(
      () => api.getBudgets(
        period: period,
        categoryId: categoryId,
        page: page,
        pageSize: pageSize,
      ),
    );
  }

  /// =======================
  /// GET BUDGET BY ID
  /// =======================
  Future<BudgetModel> getBudgetById(String id) {
    return _guardRequest(() async {
      final res = await api.getBudgetById(id);
      return res.budget;
    });
  }

  /// =======================
  /// CREATE BUDGET
  /// =======================
  Future<BudgetModel> createBudget({
    required String categoryId,
    required double amount,
    required String period,
    required int startDate,
    required int endDate,
    required double? alertThreshold,
  }) {
    final body = <String, dynamic>{
      'categoryId': categoryId,
      'amount': amount,
      'period': period,
      'startDate': startDate,
      'endDate': endDate,
      'alertThreshold': alertThreshold,
    };

    return _guardRequest(() => api.createBudget(body));
  }

  /// =======================
  /// UPDATE BUDGET
  /// =======================
  Future<BudgetModel> updateBudget({
    String? categoryId,
    required String id,
    double? amount,
    String? period,
    int? startDate,
    int? endDate,
    double? alertThreshold,
  }) {
    final body = <String, dynamic>{};
    if (categoryId != null) body['categoryId'] = categoryId;
    if (amount != null) body['amount'] = amount;
    if (period != null) body['period'] = period;
    if (startDate != null) body['startDate'] = startDate;
    if (endDate != null) body['endDate'] = endDate;
    if (alertThreshold != null) body['alertThreshold'] = alertThreshold;

    return _guardRequest(() => api.updateBudget(id, body));
  }

  /// =======================
  /// DELETE BUDGET
  /// =======================
  Future<void> deleteBudget(String id) {
    return _guardRequest(() => api.deleteBudget(id));
  }

  /// =======================
  /// ERROR HANDLER (GIỐNG PROFILE)
  /// =======================
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
