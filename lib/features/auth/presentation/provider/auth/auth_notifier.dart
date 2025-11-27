import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../domain/usecase/refresh_token_icon.dart';

/// STATE
class AuthState {
  final bool isLoggedIn;
  final bool isActive;
  final String? token;

  const AuthState({
    this.isLoggedIn = false,
    this.isActive = false,
    this.token,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isActive,
    String? token,
  }) {
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
  final Ref ref;

  Timer? _refreshTimer;

  AuthNotifier(this.refreshTokenUseCase, this.ref) : super(const AuthState()) {
    _loadAuth();
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
 

    if (token != null ) {
    
      state = state.copyWith(
        isLoggedIn: true,
        token: token,
      );

      _monitorTokenExpiry();
    }
  }

  /// Login
  Future<void> login({
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString('token', token);

    state = state.copyWith(
      isLoggedIn: true,
      token: token,
    );

    _monitorTokenExpiry();
  }

  /// Logout
  Future<void> logout() async {
    _refreshTimer?.cancel();

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
}
