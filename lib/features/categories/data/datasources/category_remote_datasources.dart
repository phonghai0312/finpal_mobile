import '../models/category_model.dart';

abstract class CategoryRemoteDataSource {
  Future<CategoryListResponseModel> getCategories({
    int page,
    int pageSize,
  });
}
