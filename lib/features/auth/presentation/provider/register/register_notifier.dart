// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/providers/previous_page_provider.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/utils/validation_auth.dart';
import '../../../domain/usecase/register_account.dart';

class RegisterState {
  final TextEditingController usernameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController bankNumberController;
  final TextEditingController bankNameController;

  final bool hasEmailError;
  final bool hasPasswordError;
  final bool hasConfirmPasswordError;
  final bool isValid;
  final bool isLoading;
  final String? errorMessage;

  const RegisterState({
    required this.usernameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.bankNumberController,
    required this.bankNameController,
    this.hasEmailError = false,
    this.hasPasswordError = false,
    this.hasConfirmPasswordError = false,
    this.isValid = false,
    this.isLoading = false,
    this.errorMessage,
  });

  RegisterState copyWith({
    bool? hasEmailError,
    bool? hasPasswordError,
    bool? hasConfirmPasswordError,
    bool? isValid,
    bool? isLoading,
    String? errorMessage,
  }) {
    return RegisterState(
      usernameController: usernameController,
      emailController: emailController,
      passwordController: passwordController,
      confirmPasswordController: confirmPasswordController,
      bankNumberController: bankNumberController,
      bankNameController: bankNameController,
      hasEmailError: hasEmailError ?? this.hasEmailError,
      hasPasswordError: hasPasswordError ?? this.hasPasswordError,
      hasConfirmPasswordError:
          hasConfirmPasswordError ?? this.hasConfirmPasswordError,
      isValid: isValid ?? this.isValid,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

class RegisterNotifier extends StateNotifier<RegisterState> {
  final RegisterAccount _registerUseCase;
  final Ref ref;

  RegisterNotifier(this._registerUseCase, this.ref)
    : super(
        RegisterState(
          usernameController: TextEditingController(),
          emailController: TextEditingController(),
          passwordController: TextEditingController(),
          confirmPasswordController: TextEditingController(),
          bankNumberController: TextEditingController(),
          bankNameController: TextEditingController(),
        ),
      ) {
    _addListeners();
  }

  // Add listeners
  void _addListeners() {
    state.emailController.addListener(_validateAll);
    state.passwordController.addListener(_validateAll);
    state.confirmPasswordController.addListener(_validateAll);
  }

  // Validate all input fields
  void _validateAll() {
    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();
    final confirmPassword = state.confirmPasswordController.text.trim();

    final emailValid = ValidationAuth.isValidEmail(email);
    final passwordValid = ValidationAuth.isStrongPassword(password);
    final confirmPasswordValid = confirmPassword == password;

    final isValid = emailValid && passwordValid && confirmPasswordValid;

    state = state.copyWith(
      hasEmailError: !emailValid && email.isNotEmpty,
      hasPasswordError: !passwordValid && password.isNotEmpty,
      hasConfirmPasswordError:
          !confirmPasswordValid && confirmPassword.isNotEmpty,
      isValid: isValid,
    );
  }

  // Handle Sign Up action
  Future<void> onSignUp(BuildContext context) async {
    if (!state.isValid) return;

    _setLoading(true);

    final email = state.emailController.text.trim();
    final password = state.passwordController.text.trim();
    final bankNumber = state.bankNumberController.text.trim();
    final bankName = state.bankNameController.text.trim();

    try {
      await _registerUseCase(
        email,
        password,
        bankNumber: bankNumber.isNotEmpty ? bankNumber : null,
        bankName: bankName.isNotEmpty ? bankName : null,
      );
      _setLoading(false);
      ref.read(previousPageProvider.notifier).state = 'register';
      context.go(AppRoutes.login);
    } catch (e) {
      _handleFailure(context, e);
    }
  }

  // Handle successful
  // void _handleSuccess(BuildContext context) {
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text(
  //         'Register account successful!, Please verify your account',
  //       ),
  //       backgroundColor: AppColors.bgPrimary,
  //       behavior: SnackBarBehavior.floating,
  //     ),
  //   );

  // }

  // Handle failure
  void _handleFailure(BuildContext context, Object error) {
    final message = _translateError(error.toString());
    state = state.copyWith(isLoading: false, errorMessage: message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.typoError,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Translate error messages
  String _translateError(String errorMessage) {
    final error = errorMessage.replaceFirst('Exception: ', '').trim();
    return error;
  }

  // Set loading state
  void _setLoading(bool loading) {
    state = state.copyWith(isLoading: loading);
  }

  // Navigate to Login page
  void onPressBack(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // Navigate to Login page
  void onSignIn(BuildContext context) {
    context.go(AppRoutes.login);
  }

  // // Handle Google login (not implemented yet)
  // void onRegisterWithGoogle(BuildContext context) {}

  // // Handle Facebook login (not implemented yet)
  // void onRegisterWithFacebook(BuildContext context) {}

  @override
  void dispose() {
    state.emailController.dispose();
    state.passwordController.dispose();
    state.confirmPasswordController.dispose();
    state.bankNumberController.dispose();
    state.bankNameController.dispose();
    super.dispose();
  }
}
