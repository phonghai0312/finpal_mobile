import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';
import 'package:fridge_to_fork_ai/features/stats/data/models/stats_by_category_model.dart';
import 'package:fridge_to_fork_ai/features/stats/data/models/stats_overview_model.dart';

part 'stats_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class StatsApi {
  factory StatsApi(Dio dio, {String? baseUrl}) = _StatsApi;

  /// GET /stats/overview
  @GET('/stats/overview')
  Future<StatsOverviewModel> getStatsOverview({
    @Query('from') required int from,
    @Query('to') required int to,
    @Query('type') String type = 'monthly',
  });

  /// GET /stats/by-category
  @GET('/stats/by-category')
  Future<StatsByCategoryModel> getStatsByCategory({
    @Query('from') required int from,
    @Query('to') required int to,
    @Query('type') String type = 'monthly',
  });
}
