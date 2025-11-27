import '../../domain/entities/refresh_token.dart';

class RefreshTokenModel extends RefreshToken {
  const RefreshTokenModel({
    required super.token,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      token: json['token'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'token': token,
  };
}
