import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/repositories/category_repository.dart';
import '../datasources/category_remote_datasources.dart';
import '../../domain/entities/category_entity.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  final CategoryRemoteDataSource remoteDataSource;

  CategoryRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<CategoryEntity>> getCategories({
    int page = 1,
    int pageSize = 20,
  }) async {
    final response = await remoteDataSource.getCategories(page: page, pageSize: pageSize);
    return response.items.map((model) => model.toEntity()).toList();
  }
}