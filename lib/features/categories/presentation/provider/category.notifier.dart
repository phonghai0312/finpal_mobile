import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';
import '../../domain/entities/category_entity.dart';
import '../../domain/usecase/get_categories_usecase.dart';

/// State
class CategoryState {
  final List<CategoryEntity> categories;
  final bool isLoading;
  final String? errorMessage;

  const CategoryState({
    this.categories = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  CategoryState copyWith({
    List<CategoryEntity>? categories,
    bool? isLoading,
    String? errorMessage,
  }) {
    return CategoryState(
      categories: categories ?? this.categories,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// Notifier
class CategoryNotifier extends StateNotifier<CategoryState> {
  final GetCategoriesUseCase getCategoriesUseCase;

  CategoryNotifier(this.getCategoriesUseCase) : super(const CategoryState()) {
    fetchCategories();
  }

  Future<void> fetchCategories({int page = 1, int pageSize = 20}) async {
    state = state.copyWith(isLoading: true, errorMessage: null);
    try {
      final categories = await getCategoriesUseCase.call(page: page, pageSize: pageSize);
      state = state.copyWith(categories: categories, isLoading: false);
    } catch (e) {
      state = state.copyWith(isLoading: false, errorMessage: e.toString());
    }
  }
}

