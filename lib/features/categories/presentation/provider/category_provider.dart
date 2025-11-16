import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/categories/data/datasources/category_remote_datasources_impl.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category.notifier.dart';
import '../../data/datasources/category_remote_datasources.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/usecase/get_categories_usecase.dart';

/// DataSource
final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
      (ref) => CategoryRemoteDataSourceImpl(),
);

/// Repository
final categoryRepositoryProvider = Provider<CategoryRepositoryImpl>(
      (ref) => CategoryRepositoryImpl(
    remoteDataSource: ref.read(categoryRemoteDataSourceProvider),
  ),
);

/// UseCase
final getCategoriesUseCaseProvider = Provider<GetCategoriesUseCase>(
      (ref) => GetCategoriesUseCase(ref.read(categoryRepositoryProvider)),
);

/// Notifier Provider
final categoryNotifierProvider = StateNotifierProvider<CategoryNotifier, CategoryState>(
      (ref) => CategoryNotifier(ref.read(getCategoriesUseCaseProvider)),
);
