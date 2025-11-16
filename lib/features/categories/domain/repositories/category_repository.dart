import '../../domain/entities/category_entity.dart';
import '../../data/models/category_model.dart';

abstract class CategoryRepository {
  Future<List<CategoryEntity>> getCategories({
    int page,
    int pageSize,
  });
}
