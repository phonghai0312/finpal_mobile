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
}
