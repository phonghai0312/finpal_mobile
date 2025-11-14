import 'package:fridge_to_fork_ai/features/auth/domain/entities/register.dart';

class RegisterModel extends Register {
  RegisterModel({
    required super.message,
    required super.success,
    required super.statusCode,
  });

  factory RegisterModel.fromJson(Map<String, dynamic> json) {
    return RegisterModel(
      message: json['message'],
      success: json['success'],
      statusCode: json['statusCode'],
    );
  }
  Map<String, dynamic> toJson() {
    return {'message': message, 'success': success, 'statusCode': statusCode};
  }
}
