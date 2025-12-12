import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_list_response_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/spend_amount_model.dart';

part 'transaction_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class TransactionApi {
  factory TransactionApi(Dio dio, {String? baseUrl}) = _TransactionApi;

  @GET('/transactions')
  Future<TransactionListResponseModel> getTransactions({
    @Query('from') int? from,
    @Query('to') int? to,
    @Query('type') String? type,
    @Query('direction') String? direction,
    @Query('categoryId') String? categoryId,
    @Query('accountId') String? accountId,
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  });

  @GET('/transactions/{id}')
  Future<TransactionModel> getTransactionDetail(@Path('id') String id);

  @PUT('/transactions/{id}')
  Future<TransactionModel> updateTransaction(
    @Path('id') String id,
    @Body() Map<String, dynamic> body,
  );

  @DELETE('/transactions/{id}')
  Future<void> deleteTransaction(@Path('id') String id);

  @POST('/transactions')
  Future<TransactionModel> createTransaction(@Body() Map<String, dynamic> body);

  @GET('/transactions/spend-amount')
  Future<SpendAmountResponseModel> getSpendAmounts({
    @Query('categoryId') String? categoryId,
  });
}


