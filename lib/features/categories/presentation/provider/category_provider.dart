import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/categories/data/api/category_api.dart';
import 'package:fridge_to_fork_ai/features/categories/data/datasources/category_remote_datasources_impl.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category.notifier.dart';
import '../../data/datasources/category_remote_datasources.dart';
import '../../data/repositories/category_repository_impl.dart';
import '../../domain/usecase/get_categories_usecase.dart';

/// Api
final categoryApiProvider = Provider<CategoryApi>(
  (ref) => ApiClient().create(CategoryApi.new),
);

/// DataSource
final categoryRemoteDataSourceProvider = Provider<CategoryRemoteDataSource>(
      (ref) => CategoryRemoteDataSourceImpl(
    api: ref.read(categoryApiProvider),
  ),
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
