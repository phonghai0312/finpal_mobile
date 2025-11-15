// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/presentation/providers/previous_page_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/utils/validation_auth.dart';
import '../../../domain/usecase/login_account.dart';
import '../auth/auth_provider.dart';

/// STATE
class LoginState {
  final TextEditingController usernameController;
  final TextEditingController passwordController;

  final bool remember;
  final bool usernameValid;
  final bool passwordValid;
  final bool hasUserNameError;
  final bool hasPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const LoginState({
    required this.usernameController,
    required this.passwordController,
    this.remember = false,
    this.usernameValid = false,
    this.passwordValid = false,
    this.hasUserNameError = false,
    this.hasPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  LoginState copyWith({
    bool? remember,
    bool? usernameValid,
    bool? passwordValid,
    bool? hasUserNameError,
    bool? hasPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return LoginState(
      usernameController: usernameController,
      passwordController: passwordController,
      remember: remember ?? this.remember,
      usernameValid: usernameValid ?? this.usernameValid,
      passwordValid: passwordValid ?? this.passwordValid,
      hasUserNameError: hasUserNameError ?? this.hasUserNameError,
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
  final Ref ref;

  LoginNotifier(this._loginUseCase, this.ref)
    : super(
        LoginState(
          usernameController: TextEditingController(),
          passwordController: TextEditingController(),
        ),
      ) {
    _loadSavedAccount();
    state.usernameController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
  }

  /// Load saved credentials
  Future<void> _loadSavedAccount() async {
    final prefs = await SharedPreferences.getInstance();

    final savedUser = prefs.getString('saved_username') ?? '';
    final savedPass = prefs.getString('saved_password') ?? '';
    final remember = prefs.getBool('remember_me') ?? false;

    state.usernameController.text = savedUser;
    state.passwordController.text = savedPass;

    state = state.copyWith(remember: remember);

    _validateAll();
  }

  /// Validate inputs
  void _validateAll() {
    final user = state.usernameController.text.trim();
    final pass = state.passwordController.text.trim();

    final userValid = ValidationAuth.isPhoneOrEmailValid(user);
    final passValid = ValidationAuth.isStrongPassword(pass);

    state = state.copyWith(
      usernameValid: userValid,
      passwordValid: passValid,
      hasUserNameError: !userValid && user.isNotEmpty,
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

    final user = state.usernameController.text.trim();
    final pass = state.passwordController.text.trim();

    try {
      final auth = await _loginUseCase(user, pass, 'app');

      await ref
          .read(authProvider.notifier)
          .login(
            accessToken: auth.accessToken,
            refreshToken: auth.refreshToken,
          );

      await _saveRemember(user, pass);

      _setLoading(false);

      if (context.mounted) context.go(AppRoutes.home);
    } catch (e) {
      _setLoading(false);

      if (context.mounted) _showError(context, _translateError(e.toString()));
    }
  }

  /// Save remember me info
  Future<void> _saveRemember(String u, String p) async {
    final prefs = await SharedPreferences.getInstance();
    if (state.remember) {
      await prefs.setString('saved_username', u);
      await prefs.setString('saved_password', p);
      await prefs.setBool('remember_me', true);
    } else {
      await prefs.remove('saved_username');
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
    return 'Đã xảy ra lỗi, vui lòng thử lại';
  }

  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value);
  }

  void onPressRegister(BuildContext context) {
    context.go(AppRoutes.register);
  }

  @override
  void dispose() {
    state.usernameController.dispose();
    state.passwordController.dispose();
    super.dispose();
  }
}
