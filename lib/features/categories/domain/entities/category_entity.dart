import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String id;
  final String userId;
  final String name;
  final String displayName;
  final String? parent;
  final String? icon;
  final int createdAt;
  final int updatedAt;

  const CategoryEntity({
    required this.id,
    required this.userId,
    required this.name,
    required this.displayName,
    this.parent,
    this.icon,
    required this.createdAt,
    required this.updatedAt,
  });

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
}
