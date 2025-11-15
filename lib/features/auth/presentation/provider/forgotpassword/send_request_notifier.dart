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
  // Future<void> onSendCode(BuildContext context) async {
  //   final input = state.username.trim();

  //   try {
  //     _setLoading(true);
  //     await _sendRequestUseCase(input);
  //     await _handleSuccess(context);
  //   } catch (e) {
  //     _handleFailure(context, e);
  //   }
  // }

  // Handle success
  // Future<void> _handleSuccess(BuildContext context) async {
  //   _setLoading(false);
  //   state = state.copyWith(isSuccess: true);

  //   context.go(AppRoutes.verifypassword);
  // }

  // // Handle failure
  // void _handleFailure(BuildContext context, Object error) {
  //   final message = _translateError(error.toString());
  //   state = state.copyWith(isLoading: false, errorMessage: message);

  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(message),
  //       backgroundColor: Colors.red,
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );
  // }

  // // Update loading state
  // void _setLoading(bool value) {
  //   state = state.copyWith(isLoading: value, errorMessage: null);
  // }

  // // Translate error messages
  // String _translateError(String errorMessage) {
  //   final error = errorMessage.replaceFirst('Exception: ', '').trim();

  //   switch (error) {
  //     case 'User not found':
  //       return 'User not found. Please try again later!';
  //     default:
  //       return 'An unexpected error occurred. Please try again later.';
  //   }
  // }

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
