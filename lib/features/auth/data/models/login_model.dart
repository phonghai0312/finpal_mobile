import 'package:fridge_to_fork_ai/features/auth/domain/entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required super.id,
    required super.phone,
    required super.email,
    required super.password,
    required super.token,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    // API response:
    // {
    //   "settings": {...},
    //   "_id": "...",
    //   "email": "...",
    //   "name": "...",
    //   "password": "...",
    //   "phone": "...",
    //   "token": "...",
    //   "menus": []
    // }
    return LoginModel(
      id: json['_id']?.toString() ?? '',
      phone: json['phone']?.toString() ?? '',
      email: json['email']?.toString() ?? '',
      password: json['password']?.toString() ?? '',
      token: json['token']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'password': password,
      'token': token,
    };
  }
}
