import 'package:fridge_to_fork_ai/core/domain/entities/user_settings.dart';

class User {
  final String? id;
  final String? email;
  final String? phone;
  final String? name;
  final String? avatarUrl;
  final UserSettings? settings;
  final int createdAt;
  final int updatedAt;

  const User({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.avatarUrl,
    this.settings,
    required this.createdAt,
    required this.updatedAt,
  });

  User copyWith({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? avatarUrl,
    UserSettings? settings,
    int? createdAt,
    int? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      name: name ?? this.name,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
