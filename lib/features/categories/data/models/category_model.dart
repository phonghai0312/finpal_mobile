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
    return CategoryModel(
      id: json['id'],
      userId: json['userId'],
      name: json['name'],
      displayName: json['displayName'],
      parent: json['parent'],
      icon: json['icon'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  // Chuyển sang JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
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
    return CategoryListResponseModel(
      items: (json['items'] as List)
          .map((item) => CategoryModel.fromJson(item))
          .toList(),
      page: json['page'],
      pageSize: json['pageSize'],
      total: json['total'],
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
