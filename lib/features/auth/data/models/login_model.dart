import 'package:fridge_to_fork_ai/features/auth/domain/entities/login.dart';

class LoginModel extends Login {
  const LoginModel({
    required super.id,
    required super.phone,
    required super.email,
    required super.password,
    required super.accessToken,
    required super.refreshToken,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    final user = json['user'] ?? {};
    return LoginModel(
      id: user['id'],
      phone: user['phone'],
      email: user['email'],
      password: user['password'],
      accessToken: json['accessToken'],
      refreshToken: json['refreshToken'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'phone': phone,
      'email': email,
      'password': password,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
