// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/domain/entities/user.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../domain/usecases/update_user_profile.dart';

class EditProfileState {
  final User? user;
  final bool isLoading;
  final bool hasChanges;
  final String? errorMessage;

  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController phoneController;

  const EditProfileState({
    this.user,
    this.isLoading = false,
    this.hasChanges = false,
    this.errorMessage,
    required this.nameController,
    required this.emailController,
    required this.phoneController,
  });

  EditProfileState copyWith({
    User? user,
    bool? isLoading,
    bool? hasChanges,
    String? errorMessage,
    TextEditingController? nameController,
    TextEditingController? emailController,
    TextEditingController? phoneController,
  }) {
    return EditProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      hasChanges: hasChanges ?? this.hasChanges,
      errorMessage: errorMessage,
      nameController: nameController ?? this.nameController,
      emailController: emailController ?? this.emailController,
      phoneController: phoneController ?? this.phoneController,
    );
  }
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final UpdateUserProfileUseCase updateUserUseCase;
  final Ref ref;

  EditProfileNotifier(this.updateUserUseCase, this.ref)
    : super(
        EditProfileState(
          nameController: TextEditingController(),
          emailController: TextEditingController(),
          phoneController: TextEditingController(),
        ),
      ) {
    _loadUser();
    _initListeners();
  }

  /// Load từ ProfileNotifier
  void _loadUser() {
    final profile = ref.read(profileNotifierProvider);
    final user = profile.user;

    if (user != null) {
      state.nameController.text = user.name ?? "";
      state.emailController.text = user.email ?? "";
      state.phoneController.text = user.phone ?? "";

      state = state.copyWith(user: user);
    }
  }

  /// Detect changes
  void _initListeners() {
    state.nameController.addListener(_checkChanges);
    state.phoneController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final user = state.user;
    if (user == null) return;

    final changed =
        state.nameController.text.trim() != (user.name ?? "") ||
        state.phoneController.text.trim() != (user.phone ?? "");

    if (changed != state.hasChanges) {
      state = state.copyWith(hasChanges: changed);
    }
  }

  void goBack(BuildContext context) => context.go(AppRoutes.profile);

  /// Save update
  Future<void> save(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      final user = state.user;
      if (user == null) throw Exception("User not found");

      final updatedUser = await updateUserUseCase.call(
        name: state.nameController.text.trim(),
        phone: state.phoneController.text.trim(),
      );

      /// update lên ProfileNotifier
      ref.read(profileNotifierProvider.notifier).setUser(updatedUser);

      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        hasChanges: false,
      );

      context.go(AppRoutes.profile);
    } catch (e) {
      _handleError(e, context);
    }
  }

  void _handleError(Object e, BuildContext context) {
    String message = "Unknown error";

    if (e is DioException) {
      final data = e.response?.data;
      if (data is Map<String, dynamic>) {
        message = data["message"]?.toString() ?? message;
      } else {
        message = e.message ?? message;
      }
    } else {
      message = e.toString();
    }

    state = state.copyWith(isLoading: false, errorMessage: message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: AppColors.typoError),
    );
  }

  @override
  void dispose() {
    state.nameController.dispose();
    state.emailController.dispose();
    state.phoneController.dispose();
    super.dispose();
  }
}
