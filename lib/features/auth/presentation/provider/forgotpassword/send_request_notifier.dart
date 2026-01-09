// Represents the state of the Send Request screen
// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/utils/validation_auth.dart';

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
  SendRequestNotifier()
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
    if (!state.isValid || state.isLoading) return;
    context.go(AppRoutes.verifyOtp);
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
