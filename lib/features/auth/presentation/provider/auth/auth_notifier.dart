import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../domain/usecase/refresh_token_icon.dart';

/// ===== STATE =====
class AuthState {
  final bool isLoggedIn;
  final String? accessToken;
  final String? refreshToken;

  const AuthState({
    this.isLoggedIn = false,
    this.accessToken,
    this.refreshToken,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    String? accessToken,
    String? refreshToken,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      accessToken: accessToken ?? this.accessToken,
      refreshToken: refreshToken ?? this.refreshToken,
    );
  }
}

/// ===== NOTIFIER =====
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

  /// 🔍 Kiểm tra token có phải JWT hợp lệ hay không
  bool isValidJwt(String token) {
    final parts = token.split('.');
    return parts.length == 3;
  }

  /// LOAD AUTH
  Future<void> _loadAuth() async {
    final prefs = await SharedPreferences.getInstance();

    final accessToken = prefs.getString('access_token');
    final refreshToken = prefs.getString('refresh_token');

    if (accessToken != null && refreshToken != null) {
      state = state.copyWith(
        isLoggedIn: true,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );

      // Chỉ monitor expiry nếu token thật
      // if (_isValidJwt(accessToken)) {
      //   _monitorTokenExpiry();
      // }
    }
  }

  /// LOGIN
  Future<void> login({
    required String accessToken,
    required String refreshToken,
  }) async {
    final prefs = await SharedPreferences.getInstance();

    // Lưu token vào SharedPreferences
    await prefs.setString('access_token', accessToken);
    await prefs.setString('refresh_token', refreshToken);

    state = state.copyWith(
      isLoggedIn: true,
      accessToken: accessToken,
      refreshToken: refreshToken,
    );

    // 👉 Nếu dùng token mock → Bỏ qua refresh logic
    // if (_isValidJwt(accessToken)) {
    //   _monitorTokenExpiry();
  }
}
