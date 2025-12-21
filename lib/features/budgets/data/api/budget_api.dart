import 'package:dio/dio.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/budget_detail_response_model.dart';
import 'package:retrofit/retrofit.dart';

import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/models/budget_model.dart';

part 'budget_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class BudgetApi {
  factory BudgetApi(Dio dio, {String? baseUrl}) = _BudgetApi;

  @GET('/budgets/spend')
  Future<BudgetListResponseModel> getBudgets({
    @Query('period') String? period,
    @Query('categoryId') String? categoryId,
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET('/budgets/{id}')
  Future<BudgetDetailResponse> getBudgetById(@Path('id') String id);

  @POST('/budgets')
  Future<BudgetModel> createBudget(@Body() Map<String, dynamic> body);

  @PUT('/budgets/{id}')
  Future<BudgetModel> updateBudget(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/budgets/{id}')
  Future<void> deleteBudget(@Path('id') String id);
}
