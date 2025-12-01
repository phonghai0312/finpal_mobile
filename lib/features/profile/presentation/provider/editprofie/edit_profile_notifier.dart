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

  const EditProfileState({
    this.user,
    this.isLoading = false,
    this.hasChanges = false,
    this.errorMessage,
  });

  EditProfileState copyWith({
    User? user,
    bool? isLoading,
    bool? hasChanges,
    String? errorMessage,
  }) {
    return EditProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      hasChanges: hasChanges ?? this.hasChanges,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }
}

class EditProfileNotifier extends StateNotifier<EditProfileState> {
  final UpdateUserProfileUseCase updateUserUseCase;
  final Ref ref;

  // Controllers should NOT be in state.
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();

  EditProfileNotifier(this.updateUserUseCase, this.ref)
    : super(const EditProfileState()) {
    _loadUser();
    _initListeners();
  }

  void _loadUser() {
    final profile = ref.read(profileNotifierProvider);
    final user = profile.user;

    if (user != null) {
      nameController.text = user.name ?? "";
      emailController.text = user.email ?? "";
      phoneController.text = user.phone ?? "";

      state = state.copyWith(user: user);
    }
  }

  void _initListeners() {
    nameController.addListener(_checkChanges);
    phoneController.addListener(_checkChanges);
  }

  void _checkChanges() {
    final user = state.user;
    if (user == null) return;

    final changed =
        nameController.text.trim() != (user.name ?? "") ||
        phoneController.text.trim() != (user.phone ?? "");

    if (changed != state.hasChanges) {
      state = state.copyWith(hasChanges: changed);
    }
  }

  Future<void> onUpdate(BuildContext context) async {
    try {
      state = state.copyWith(isLoading: true);

      // 1. Gửi API UPDATE
      final updatedUser = await updateUserUseCase(
        name: nameController.text.trim(),
        phone: phoneController.text.trim(),
      );

      await ref.read(profileNotifierProvider.notifier).fetchProfile(context);

      final newUser = ref.read(profileNotifierProvider).user;

      if (newUser != null) {
        nameController.text = newUser.name ?? "";
        phoneController.text = newUser.phone ?? "";
        emailController.text = newUser.email ?? "";

        // cập nhật luôn state của EditPage
        state = state.copyWith(
          user: newUser,
          isLoading: false,
          hasChanges: false,
        );
      } else {
        // fallback: dùng updatedUser
        state = state.copyWith(
          user: updatedUser,
          isLoading: false,
          hasChanges: false,
        );
      }

      if (context.mounted) {
        context.go(AppRoutes.profile);
      }
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
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  void onBack(BuildContext context) {
    context.go(AppRoutes.profile);
  }
}
