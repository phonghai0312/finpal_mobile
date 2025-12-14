import 'package:fridge_to_fork_ai/features/auth/domain/entities/fcm_token.dart';

class FcmTokenModel extends FcmToken {
  FcmTokenModel({super.message, required super.success, super.statusCode});

  factory FcmTokenModel.fromJson(Map<String, dynamic> json) {
    return FcmTokenModel(
      message: json['message'] as String?,
      success: json['success'] as bool? ?? false,
      statusCode: json['statusCode'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (message != null) 'message': message,
      'success': success,
      if (statusCode != null) 'statusCode': statusCode,
    };
  }
}



