import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String displayName;
  final String? parent;
  final String? icon;
  final int createdAt;
  final int updatedAt;

  const CategoryModel({
    required this.id,
    required this.userId,
    required this.name,
    required this.displayName,
    this.parent,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => _$CategoryModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  @override
  List<Object?> get props => [
        id,
        userId,
        name,
        displayName,
        parent,
        icon,
        createdAt,
        updatedAt,
      ];

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

@JsonSerializable()
class CategoryListResponseModel extends Equatable {
  final List<CategoryModel> items;
  final int page;
  final int pageSize;
  final int total;

  const CategoryListResponseModel({
    required this.items,
    required this.page,
    required this.pageSize,
    required this.total,
  });

  factory CategoryListResponseModel.fromJson(Map<String, dynamic> json) => _$CategoryListResponseModelFromJson(json);
  Map<String, dynamic> toJson() => _$CategoryListResponseModelToJson(this);

  @override
  List<Object?> get props => [items, page, pageSize, total];
}
