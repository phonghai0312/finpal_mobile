import 'package:fridge_to_fork_ai/features/categories/domain/entities/category_entity.dart';

class CategoryModel {
  final String id;
  final String userId;
  final String name;
  final String displayName;
  final String? parent;
  final String? icon;
  final int createdAt;
  final int updatedAt;

  CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.displayName,
    this.parent,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  // Tạo từ JSON
  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'] ?? json['id'];
    final rawUser = json['user'] ?? json['userId'];
    return CategoryModel(
      id: rawId?.toString() ?? '',
      userId: rawUser?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      displayName: json['displayName']?.toString() ?? '',
      parent: json['parent']?.toString(),
      icon: json['icon']?.toString(),
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'user': userId,
      'name': name,
      'displayName': displayName,
      'parent': parent,
      'icon': icon,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  // Chuyển sang Entity
  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      userId: userId,
      name: name,
      displayName: displayName,
      parent: parent,
      icon: icon,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

// Nếu cần list response
class CategoryListResponseModel {
  final List<CategoryModel> items;
  final int page;
  final int pageSize;
  final int total;

  CategoryListResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory CategoryListResponseModel.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>?) ?? const <dynamic>[];
    return CategoryListResponseModel(
      items: rawItems
          .map((item) => CategoryModel.fromJson(item as Map<String, dynamic>))
          .toList(),
      page: (json['page'] as num?)?.toInt() ?? 1,
      pageSize: (json['pageSize'] as num?)?.toInt() ?? rawItems.length,
      total: (json['total'] as num?)?.toInt() ?? rawItems.length,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'items': items.map((e) => e.toJson()).toList(),
      'page': page,
      'pageSize': pageSize,
      'total': total,
    };
  }
}
