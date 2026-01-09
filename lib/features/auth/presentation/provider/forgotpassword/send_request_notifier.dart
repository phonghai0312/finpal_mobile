// Represents the state of the Send Request screen
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation_auth.dart';
import '../../../domain/usecase/send_request.dart';

class SendRequestState {
  final TextEditingController usernameController;
  final String username;
  final bool usernameValid;
  final bool hasPhoneOrEmailError;
  final bool isValid;
  final bool isLoading;
  final bool isSuccess;
  final String? errorMessage;

  const SendRequestState({
    required this.usernameController,
    this.username = '',
    this.usernameValid = false,
    this.hasPhoneOrEmailError = false,
    this.isValid = false,
    this.isLoading = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SendRequestState copyWith({
    TextEditingController? usernameController,
    String? username,
    bool? usernameValid,
    bool? hasPhoneOrEmailError,
    bool? isValid,
    bool? isLoading,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SendRequestState(
      usernameController: usernameController ?? this.usernameController,
      username: username ?? this.username,
      usernameValid: usernameValid ?? this.usernameValid,
      hasPhoneOrEmailError: hasPhoneOrEmailError ?? this.hasPhoneOrEmailError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }
}

class SendRequestNotifier extends StateNotifier<SendRequestState> {
  final SendRequest sendRequestUseCase;

  SendRequestNotifier(this.sendRequestUseCase)
    : super(SendRequestState(usernameController: TextEditingController())) {
    _initListeners();
  }

  // Listen to input changes and validate
  void _initListeners() {
    state.usernameController.addListener(_validateInput);
  }

  // Validate phone or email input
  void _validateInput() {
    final text = state.usernameController.text.trim();

    // true = valid input
    final valid = ValidationAuth.isPhoneOrEmailValid(text);

    // true = show red border
    final hasPhoneOrEmailError = !valid && text.isNotEmpty;

    state = state.copyWith(
      username: text,
      usernameValid: valid,
      hasPhoneOrEmailError: hasPhoneOrEmailError,
      isValid: valid,
    );
  }

  // Trigger when user presses "Send Code"
  Future<void> onSendCode(BuildContext context) async {
    final input = state.username.trim();
    if (!state.isValid || state.isLoading) return;

    try {
      _setLoading(true);
      await sendRequestUseCase(input);
      await _handleSuccess(context);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  Future<void> _handleSuccess(BuildContext context) async {
    _setLoading(false);
    state = state.copyWith(isSuccess: true);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đã gửi yêu cầu. Vui lòng kiểm tra email/số điện thoại.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleFailure(BuildContext context, Object error) {
    final message = _translateError(error.toString());
    state = state.copyWith(isLoading: false, errorMessage: message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _setLoading(bool value) {
    state = state.copyWith(isLoading: value, errorMessage: null);
  }

  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();

    switch (error) {
      case 'Invalid username':
        return 'Email hoặc số điện thoại không hợp lệ.';
      case 'User not found':
        return 'Không tìm thấy người dùng. Vui lòng thử lại.';
      default:
        return 'Có lỗi xảy ra. Vui lòng thử lại.';
    }
  }

  // Navigate to Login page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.login);
  }

  void onPressSignIn(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // Dispose controller when not needed
  @override
  void dispose() {
    state.usernameController.dispose();
    super.dispose();
  }
}
