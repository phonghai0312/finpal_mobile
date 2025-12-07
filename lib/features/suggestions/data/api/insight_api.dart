import 'package:dio/dio.dart';
import 'package:fridge_to_fork_ai/features/suggestions/data/models/insight_response_model.dart';
import 'package:retrofit/retrofit.dart';

import '../../../../core/config/constant/api_base.dart';
import '../models/insight_model.dart';

part 'insight_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class InsightApi {
  factory InsightApi(Dio dio, {String? baseUrl}) = _InsightApi;
  @GET('/insights')
  Future<InsightResponseModel> getInsights(
    @Query('type') String? type,
    @Query('page') int? page,
    @Query('pageSize') int? pageSize,
  );
}
