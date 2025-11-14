import '../../domain/entities/refresh_token.dart';

class RefreshTokenModel extends RefreshToken {
  const RefreshTokenModel({
    required super.accessToken,
    required super.tokenType,
    required super.expiresIn,
  });

  factory RefreshTokenModel.fromJson(Map<String, dynamic> json) {
    return RefreshTokenModel(
      accessToken: json['access_token'] ?? '',
      tokenType: json['token_type'] ?? '',
      expiresIn: json['expires_in'] ?? '',
    );
  }

  Map<String, dynamic> toJson() => {
    'access_token': accessToken,
    'token_type': tokenType,
    'expires_in': expiresIn,
  };
}
