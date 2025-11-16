// ignore_for_file: use_super_parameters

import 'package:fridge_to_fork_ai/core/domain/entities/user_settings.dart';
import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';

class UserModel extends User {
  UserModel({
    String? id,
    String? email,
    String? phone,
    String? name,
    String? avatarUrl,
    UserSettings? settings,
    required int createdAt,
    required int updatedAt,
  }) : super(
         id: id,
         email: email,
         phone: phone,
         name: name,
         avatarUrl: avatarUrl,
         settings: settings,
         createdAt: createdAt,
         updatedAt: updatedAt,
       );

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      email: json['email'],
      phone: json['phone'],
      name: json['name'],
      avatarUrl: json['avatarUrl'],
      // Nếu settings null → để null luôn
      settings: null,
      createdAt: json['createdAt'] ?? 0,
      updatedAt: json['updatedAt'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "email": email,
    "phone": phone,
    "name": name,
    "avatarUrl": avatarUrl,
    "settings": null, // tạm chưa implement
    "createdAt": createdAt,
    "updatedAt": updatedAt,
  };
}
