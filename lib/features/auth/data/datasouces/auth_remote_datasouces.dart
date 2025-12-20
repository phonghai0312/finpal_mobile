import 'package:dio/dio.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/core/utils/validation_auth.dart';
import 'package:fridge_to_fork_ai/features/auth/data/api/auth_api.dart';
import 'package:fridge_to_fork_ai/features/auth/data/api/fcm_token_api.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/login_model.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/register_model.dart';
import 'package:fridge_to_fork_ai/features/auth/data/models/fcm_token_model.dart';

import '../models/refresh_token_model.dart';

class AuthRemoteDataSource {
  AuthRemoteDataSource({
    AuthApi? api,
    FcmTokenApi? fcmTokenApi,
    ApiClient? client,
  }) : _api = api ?? (client ?? ApiClient()).create(AuthApi.new),
       _fcmTokenApi =
           fcmTokenApi ?? (client ?? ApiClient()).create(FcmTokenApi.new);

  final AuthApi _api;
  final FcmTokenApi _fcmTokenApi;
  LoginModel? _session;

  /// LOGIN
  Future<LoginModel> login(String input, String password) async {
    if (!ValidationAuth.isPhoneOrEmailValid(input)) {
      throw Exception("Invalid phone number or email");
    }

    if (!ValidationAuth.isStrongPassword(password)) {
      throw Exception("Weak password");
    }

    final requestBody = {"email": input, "password": password};

    final user = await _guardRequest(() => _api.login(requestBody));
    _session = user;
    return user;
  }

  /// REGISTER (NEW)
  Future<RegisterModel> register(
    String email,
    String password, {
    String? bankNumber,
    String? bankName,
  }) async {
    if (!ValidationAuth.isValidEmail(email)) {
      throw Exception("Invalid email");
    }

    if (!ValidationAuth.isStrongPassword(password)) {
      throw Exception("Weak password");
    }

    final requestBody = {
      "email": email,
      "password": password,
      if (bankNumber != null && bankNumber.isNotEmpty) "bankNumber": bankNumber,
      if (bankName != null && bankName.isNotEmpty) "bankName": bankName,
    };

    return _guardRequest(() => _api.register(requestBody));
  }

  /// LOGOUT
  Future<void> logout() async {
    _session = null;
  }

  /// CURRENT USER
  Future<LoginModel?> currentUser() async {
    return _session;
  }

  Future<RefreshTokenModel> refreshToken() async {
    return _guardRequest(() => _api.refreshToken());
  }

  Future<void> verify(String username, String code, String purpose) async {
    if (!ValidationAuth.isPhoneOrEmailValid(username)) {
      throw Exception("Invalid username");
    }
    if (code.isEmpty) {
      throw Exception("Verification code is required");
    }
    final requestBody = {
      "username": username,
      "code": code,
      "purpose": purpose,
    };
    await _guardRequest(() => _api.verify(requestBody));
  }

  Future<void> sendRequest(String username) async {
    if (!ValidationAuth.isPhoneOrEmailValid(username)) {
      throw Exception("Invalid username");
    }
    final requestBody = {"username": username};
    await _guardRequest(() => _api.sendRequest(requestBody));
  }

  /// REGISTER FCM TOKEN
  Future<FcmTokenModel> registerFcmToken({
    required String userId,
    required String deviceId,
    required String fcmToken,
    required String platform,
  }) async {
    final requestBody = {
      "userId": userId,
      "deviceId": deviceId,
      "fcmToken": fcmToken,
      "platform": platform,
    };

    return _guardRequest(() => _fcmTokenApi.registerToken(requestBody));
  }

  /// DEACTIVE FCM TOKEN (khi user logout hoặc đổi thiết bị)
  Future<void> deactiveFcmToken({
    required String userId,
    required String deviceId,
  }) async {
    final requestBody = {
      "userId": userId,
      "deviceId": deviceId,
    };

    return _guardRequest(() => _fcmTokenApi.deactiveToken(requestBody));
  }

  Future<T> _guardRequest<T>(Future<T> Function() request) async {
    try {
      return await request();
    } on DioException catch (dioError) {
      final dynamic data = dioError.response?.data;
      final message = (data is Map && data['message'] is String)
          ? data['message'] as String
          : dioError.message;
      throw Exception(message ?? "Unexpected server error");
    } catch (error) {
      throw Exception(error.toString());
    }
  }
}
