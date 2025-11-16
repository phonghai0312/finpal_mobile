import '../entities/category_entity.dart';
import '../repositories/category_repository.dart';

class GetCategoriesUseCase {
  final CategoryRepository repository;

  GetCategoriesUseCase(this.repository);

  Future<List<CategoryEntity>> call({
    int page = 1,
    int pageSize = 20,
  }) async {
    return await repository.getCategories(page: page, pageSize: pageSize);
  }
}
