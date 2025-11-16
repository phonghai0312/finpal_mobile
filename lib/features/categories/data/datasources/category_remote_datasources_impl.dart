import 'package:fridge_to_fork_ai/features/categories/data/models/category_model.dart';

import 'category_remote_datasources.dart';

class CategoryRemoteDataSourceImpl implements CategoryRemoteDataSource {
  // Mock data for categories
  final List<CategoryModel> _mockCategories = [
    const CategoryModel(
      id: 'c001',
      userId: 'u001',
      name: 'an_uong',
      displayName: 'Ăn uống',
      icon: 'fastfood',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
    const CategoryModel(
      id: 'c002',
      userId: 'u001',
      name: 'mua_sam',
      displayName: 'Mua sắm',
      icon: 'shopping_bag',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
    const CategoryModel(
      id: 'c003',
      userId: 'u001',
      name: 'thu_nhap',
      displayName: 'Thu nhập',
      icon: 'attach_money',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
    const CategoryModel(
      id: 'c004',
      userId: 'u001',
      name: 'di_chuyen',
      displayName: 'Di chuyển',
      icon: 'directions_car',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
    const CategoryModel(
      id: 'c005',
      userId: 'u001',
      name: 'suc_khoe',
      displayName: 'Sức khỏe',
      icon: 'medical_services',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
    const CategoryModel(
      id: 'c006',
      userId: 'u001',
      name: 'nha_cua',
      displayName: 'Nhà cửa',
      icon: 'home',
      createdAt: 1678886400,
      updatedAt: 1678886400,
    ),
  ];

  @override
  Future<CategoryListResponseModel> getCategories({
    int page = 1,
    int pageSize = 20,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));

    final total = _mockCategories.length;
    final startIndex = (page - 1) * pageSize;
    final endIndex = (startIndex + pageSize).clamp(0, total);
    final items = _mockCategories.sublist(startIndex, endIndex);

    return CategoryListResponseModel(
      items: items,
      page: page,
      pageSize: pageSize,
      total: total,
    );
  }
}
