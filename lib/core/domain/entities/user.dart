import 'package:fridge_to_fork_ai/core/domain/entities/user_settings.dart';

class User {
  final String? id;
  final String? email;
  final String? phone;
  final String? name;
  final String? avatarUrl;
  final int totalIncome;
  final int totalExpense;
  final UserSettings? settings;
  final int createdAt;
  final int updatedAt;

  const User({
    this.id,
    this.email,
    this.phone,
    this.name,
    this.avatarUrl,
    this.totalIncome = 0,
    this.totalExpense = 0,
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
    int? totalIncome,
    int? totalExpense,
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
      totalIncome: totalIncome ?? this.totalIncome,
      totalExpense: totalExpense ?? this.totalExpense,
      settings: settings ?? this.settings,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
