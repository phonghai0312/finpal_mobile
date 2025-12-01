import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/categories/data/api/category_api.dart';
import 'package:fridge_to_fork_ai/features/categories/data/models/category_model.dart';

import 'category_remote_datasources.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  CategoryRemoteDataSourceImpl({CategoryApi? api, ApiClient? client})
    : _api = api ?? (client ?? ApiClient()).create(CategoryApi.new);

  final CategoryApi _api;

  @override
  Future<CategoryListResponseModel> getCategories({
    int page = 1,
    int pageSize = 20,
  }) {
    return _guardRequest(
      () => _api.getCategories(page: page, pageSize: pageSize),
    );
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
