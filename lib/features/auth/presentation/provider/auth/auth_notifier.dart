import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/services/fcm_service.dart';
import '../../../domain/usecase/refresh_token_icon.dart';
import '../../../domain/usecase/register_fcm_token.dart';

/// STATE
class AuthState {
  final bool isLoggedIn;
  final bool isActive;
  final String? token;

  const AuthState({this.isLoggedIn = false, this.isActive = false, this.token});

  AuthState copyWith({bool? isLoggedIn, bool? isActive, String? token}) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isActive: isActive ?? this.isActive,
      token: token ?? this.token,
    );
  }
}

/// NOTIFIER
class AuthNotifier extends StateNotifier<AuthState> {
  final RefreshTokenAccount refreshTokenUseCase;
  final RegisterFcmToken registerFcmTokenUseCase;
  final Ref ref;

  Timer? _refreshTimer;
  final FcmService _fcmService = FcmService();

  AuthNotifier(this.refreshTokenUseCase, this.registerFcmTokenUseCase, this.ref)
    : super(const AuthState()) {
    _loadAuth();
    _setupFcmTokenRefresh();
  }

  /// Setup FCM token refresh listener
  void _setupFcmTokenRefresh() {
    // Lắng nghe token refresh từ FCM service
    // Token refresh sẽ được xử lý trong _registerFcmToken
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }

  /// Load auth
  Future<void> _loadAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      state = state.copyWith(isLoggedIn: true, token: token);

      _monitorTokenExpiry();

      // Đăng ký FCM token nếu đã login
      await _registerFcmToken(token);
    }
  }

  /// Login
  Future<void> login({required String token}) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);

    state = state.copyWith(isLoggedIn: true, token: token);

    _monitorTokenExpiry();

    // Đăng ký FCM token sau khi login
    await _registerFcmToken(token);
  }

  /// Logout
  Future<void> logout() async {
    _refreshTimer?.cancel();

    // Deactivate FCM token trước khi logout
    await _deactivateFcmToken();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    state = const AuthState(isLoggedIn: false);
  }

  /// Refresh access token
  Future<void> refreshAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    final refreshToken = prefs.getString('refresh_token');

    if (refreshToken == null) return;

    try {
      final result = await refreshTokenUseCase();

      if (result.token.isEmpty) {
        await logout();
        return;
      }

      await prefs.setString('token', result.token);
      state = state.copyWith(token: result.token);

      _monitorTokenExpiry();
    } catch (e) {
      await logout();
    }
  }

  /// Monitor token expiry
  void _monitorTokenExpiry() {
    _refreshTimer?.cancel();

    final token = state.token;
    if (token == null) return;

    try {
      final expiry = JwtDecoder.getExpirationDate(token);
      final refreshAt = expiry.subtract(const Duration(minutes: 1));
      final now = DateTime.now();

      final delay = refreshAt.isBefore(now)
          ? Duration.zero
          : refreshAt.difference(now);

      _refreshTimer = Timer(delay, () async {
        await refreshAccessToken();
      });
    } catch (e) {
      logout();
    }
  }

  /// Lấy userId từ JWT token
  String? _getUserIdFromToken(String token) {
    try {
      final decodedToken = JwtDecoder.decode(token);
      return decodedToken['_id']?.toString() ?? decodedToken['id']?.toString();
    } catch (e) {
      debugPrint('Error decoding token: $e');
      return null;
    }
  }

  /// Đăng ký FCM token
  Future<void> _registerFcmToken(String authToken) async {
    try {
      final userId = _getUserIdFromToken(authToken);
      if (userId == null) {
        debugPrint('Cannot get userId from token');
        return;
      }

      final fcmToken = await _fcmService.getToken();
      if (fcmToken == null || fcmToken.isEmpty) {
        debugPrint('FCM token is null or empty');
        return;
      }

      final deviceId = _fcmService.getDeviceId();
      final platform = Platform.isAndroid ? 'android' : 'ios';

      await registerFcmTokenUseCase.call(
        userId: userId,
        deviceId: deviceId,
        fcmToken: fcmToken,
        platform: platform,
      );

      debugPrint('FCM token registered successfully');
    } catch (e) {
      debugPrint('Error registering FCM token: $e');
    }
  }

  /// Deactivate FCM token
  Future<void> _deactivateFcmToken() async {
    try {
      final authToken = state.token;
      if (authToken == null) {
        // Nếu không có token, chỉ cần delete FCM token local
        await _fcmService.deleteToken();
        return;
      }

      final userId = _getUserIdFromToken(authToken);
      if (userId == null) {
        await _fcmService.deleteToken();
        return;
      }

      // Xóa token trên server (có thể gọi API deactivate nếu có)
      // Hiện tại chỉ xóa token local
      await _fcmService.deleteToken();
      debugPrint('FCM token deactivated');
    } catch (e) {
      debugPrint('Error deactivating FCM token: $e');
    }
  }

  /// Handle FCM token refresh
  Future<void> handleFcmTokenRefresh(String newToken) async {
    if (!state.isLoggedIn || state.token == null) {
      return;
    }

    await _registerFcmToken(state.token!);
  }
}
