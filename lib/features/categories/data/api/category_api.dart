import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

import 'package:fridge_to_fork_ai/core/config/constant/api_base.dart';
import 'package:fridge_to_fork_ai/features/categories/data/models/category_model.dart';

part 'category_api.g.dart';

@RestApi(baseUrl: ApiBaseDev.baseUrlDevelopment)
abstract class CategoryApi {
  factory CategoryApi(Dio dio, {String? baseUrl}) = _CategoryApi;

  @GET('/categories')
  Future<CategoryListResponseModel> getCategories({
    @Query('page') int page = 1,
    @Query('pageSize') int pageSize = 20,
  });
}


