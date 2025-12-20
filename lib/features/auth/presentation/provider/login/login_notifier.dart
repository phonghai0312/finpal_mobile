// ignore_for_file: use_build_context_synchronously, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/fcm_token.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/utils/validation_auth.dart';
import '../../../domain/usecase/login_account.dart';
import '../../../domain/usecase/register_fcm_token.dart';
import '../auth/auth_provider.dart';
import '../../../../../core/notifications/fcm_service.dart';

/// STATE
class LoginState {
  final TextEditingController emailController;
  final TextEditingController passwordController;

  final bool remember;
  final bool emailValid;
  final bool passwordValid;
  final bool hasEmailError;
  final bool hasPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    required this.emailController,
    required this.passwordController,
    this.remember = false,
    this.emailValid = false,
    this.passwordValid = false,
    this.hasEmailError = false,
    this.hasPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? remember,
    bool? emailValid,
    bool? passwordValid,
    bool? hasEmailError,
    bool? hasPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      emailController: emailController,
      passwordController: passwordController,
      remember: remember ?? this.remember,
      emailValid: emailValid ?? this.emailValid,
      passwordValid: passwordValid ?? this.passwordValid,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

/// NOTIFIER
class LoginNotifier extends StateNotifier<LoginState> {
  final LoginAccount _loginUseCase;
  final RegisterFcmToken _registerFcmTokenUseCase;
  final Ref ref;

  LoginNotifier(this._loginUseCase, this._registerFcmTokenUseCase, this.ref)
    : super(
        LoginState(
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      ) {
    _loadSavedAccount();
    state.emailController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
  }

  /// Load saved credentials
  Future<void> _loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();

    final savedUser = prefs.getString('saved_email') ?? '';
    final savedPass = prefs.getString('saved_password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    state.emailController.text = savedUser;
    state.passwordController.text = savedPass;

    state = state.copyWith(remember: remember);

    _validateAll();
  }

  /// Validate inputs
  void _validateAll() {
    final user = state.emailController.text.trim();
    final pass = state.passwordController.text.trim();

    final userValid = ValidationAuth.isPhoneOrEmailValid(user);
    final passValid = ValidationAuth.isStrongPassword(pass);

    state = state.copyWith(
      emailValid: userValid,
      passwordValid: passValid,
      hasEmailError: !userValid && user.isNotEmpty,
      hasPasswordError: !passValid && pass.isNotEmpty,
      isValid: userValid && passValid,
    );
  }

  /// Toggle remember me
  void toggleRemember(bool? value) {
    state = state.copyWith(remember: value ?? false);
  }

  /// Login
  Future<void> onSignIn(BuildContext context) async {
    if (!state.isValid) return;

    _setLoading(true);

    final email = state.emailController.text.trim();
    final pass = state.passwordController.text.trim();

    try {
      final auth = await _loginUseCase(email, pass);

      if (auth.token == null || auth.token.isEmpty) {
        _setLoading(false);
        if (context.mounted) {
          _showError(context, 'Đăng nhập thất bại');
        }
        return;
      }

      // Lưu token vào provider
      await ref.read(authProvider.notifier).login(token: auth.token);

      // Đăng ký / cập nhật FCM token sau khi đăng nhập (không block login nếu thất bại)
      try {
        await _registerFcmTokenSafely(auth.id);
      } catch (e) {
        // Log lỗi nhưng không block login flow
      }

      // Lưu remember me nếu cần
      await _saveRemember(email, pass);

      _setLoading(false);

      // Chuyển sang màn hình welcome
      if (context.mounted) {
        context.go(AppRoutes.welcome);
      } else {}
    } catch (e) {
      _setLoading(false);

      // Đây chỉ còn bắt các lỗi network, timeout, server 500...
      if (context.mounted) {
        _showError(context, _translateError(e.toString()));
      }
    }
  }

  /// Save remember me info
  Future<void> _saveRemember(String u, String p) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.remember) {
      await prefs.setString('saved_email', u);
      await prefs.setString('saved_password', p);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_email');
      await prefs.remove('saved_password');
      await prefs.setBool('remember_me', false);
    }
  }

  /// Error UI
  void _showError(BuildContext context, String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text), backgroundColor: AppColors.typoError),
    );
  }

  /// Map server errors → user-friendly message
  String _translateError(String err) {
    err = err.replaceFirst('Exception:', '').trim().toLowerCase();

    if (err.contains('wrong credentials')) return 'Sai tài khoản hoặc mật khẩu';
    if (err.contains('user not found')) return 'Không tìm thấy người dùng';
    if (err.contains('connect')) return 'Không thể kết nối máy chủ';
    return err;
  }

  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  /// Đăng ký / update FCM token với backend
  Future<FcmToken?> _registerFcmTokenSafely(String userId) async {
    try {
      final fcmToken = await FcmService.getToken();

      if (fcmToken == null || fcmToken.isEmpty) {
        return FcmToken(success: false);
      }

      const deviceId = 'unknown-device';
      const platform = 'android';

      final result = await _registerFcmTokenUseCase(
        userId: userId,
        deviceId: deviceId,
        fcmToken: fcmToken,
        platform: platform,
      );

      return result;
    } catch (error) {
      return null;
    }
  }

  void onPressRegister(BuildContext context) {
    context.go(AppRoutes.register);
  }

  void onPressForgotPassword(BuildContext context) {
    context.go(AppRoutes.sendrequest);
  }

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}
