// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/domain/entities/user.dart';
import '../../../../auth/presentation/provider/auth/auth_provider.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/logout.dart';

class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;

  const ProfileState({this.user, this.isLoading = false, this.error});

  ProfileState copyWith({User? user, bool? isLoading, String? error}) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase getUserProfile;
  final LogoutUseCase logoutUseCase;
  final Ref ref;

  ProfileNotifier(this.getUserProfile, this.logoutUseCase, this.ref)
    : super(const ProfileState());

  /// -------------------------------------
  /// LOAD THÔNG TIN TRANG PROFILE
  /// -------------------------------------
  Future<void> init(BuildContext context) async {
    if (state.user != null) return;
    await fetchProfile(context);
  }

  Future<void> fetchProfile(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await getUserProfile.call();
      state = state.copyWith(user: user, isLoading: false);
    } catch (e) {
      _handleError(context, e);
    }
  }

  /// -------------------------------------
  /// LOGOUT
  /// -------------------------------------
  Future<void> logout(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      // ✅ Gọi API logout backend trước
      await logoutUseCase.call();
      
      // ✅ Deactive FCM token và clear auth state
      // AuthNotifier.logout() sẽ tự động deactive FCM token
      await ref.read(authProvider.notifier).logout();
      
      state = const ProfileState(user: null);
      context.go(AppRoutes.login);
    } catch (e) {
      _handleError(context, e);
    }
  }

  /// -------------------------------------
  /// CHUYỂN TRANG
  /// -------------------------------------
  void goToEditProfile(BuildContext context) =>
      context.go(AppRoutes.editProfile);

  void goToSettings(BuildContext context) => context.go(AppRoutes.userSettings);

  void goToAboutApp(BuildContext context) => context.go(AppRoutes.aboutApp);

  void goToHelpSupport(BuildContext context) {
    // Chuyển đến trang Help & Support (nếu có)
  }
  void setUser(User updatedUser) {
    state = state.copyWith(user: updatedUser);
  }

  /// ERROR handler
  void _handleError(BuildContext context, Object error) {
    String message = 'Unknown error';

    if (error is DioException) {
      final data = error.response?.data;
      if (data is Map<String, dynamic>) {
        message = data['message'] ?? message;
      } else {
        message = error.message ?? message;
      }
    } else {
      message = error.toString();
    }

    state = state.copyWith(isLoading: false, error: message);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppColors.typoError,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
