import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';

import 'user_settings_model.dart';

class UserModel extends User {
  const UserModel({
    required super.id,
    required super.email,
    required super.phone,
    required super.name,
    required super.totalIncome,
    required super.totalExpense,
    required super.avatarUrl,
    required super.settings,
    required super.createdAt,
    required super.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    final rawId = json['_id'] ?? json['id'];
    if (rawId == null) {
      throw Exception('UserModel.fromJson: missing _id/id field');
    }

    return UserModel(
      id: rawId.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      name: json['name']?.toString(),
      totalIncome: (json['totalIncome'] as num?)?.toInt() ?? 0,
      totalExpense: (json['totalExpense'] as num?)?.toInt() ?? 0,
      avatarUrl: json['avatarUrl']?.toString(),
      settings: json['settings'] != null
          ? UserSettingsModel.fromJson(json['settings'] as Map<String, dynamic>)
          : null,
      createdAt: (json['createdAt'] as num?)?.toInt() ?? 0,
      updatedAt: (json['updatedAt'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'email': email,
      'phone': phone,
      'name': name,
      'totalIncome': totalIncome,
      'totalExpense': totalExpense,
      'avatarUrl': avatarUrl,
      'settings': settings is UserSettingsModel
          ? (settings! as UserSettingsModel).toJson()
          : settings,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}
