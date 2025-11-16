import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/entities/category_entity.dart';
import '../../../domain/usecase/get_categories_usecase.dart';
import '../../../data/repositories/category_repository_impl.dart';

final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>((ref) {
  final repository = ref.read(categoryRepositoryProvider);
  return GetCategoriesUseCase(repository);
});

class CategoryNotifier extends StateNotifier<AsyncValue<List<CategoryEntity>>> {
  final GetCategoriesUseCase _getCategoriesUseCase;

  CategoryNotifier(this._getCategoriesUseCase) : super(const AsyncValue.loading());

  Future<void> fetchCategories() async {
    state = const AsyncValue.loading();
    try {
      final categories = await _getCategoriesUseCase.call();
      state = AsyncValue.data(categories);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, AsyncValue<List<CategoryEntity>>>((ref) {
  final getCategoriesUseCase = ref.watch(getCategoriesUseCaseProvider);
  return CategoryNotifier(getCategoriesUseCase);
});

final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  return ref.watch(categoryNotifierProvider.notifier)._getCategoriesUseCase.call();
});
