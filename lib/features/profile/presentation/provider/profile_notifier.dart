// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/profile/data/models/user_settings_update_request_model.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/usecases/get_user_profile.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/usecases/logout.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/usecases/update_user_profile.dart';
import 'package:go_router/go_router.dart';

class ProfileFormState {
  final String? name;
  final String? email;
  final bool? notificationEnabled;

  ProfileFormState({this.name, this.email, this.notificationEnabled});

  ProfileFormState copyWith({
    String? name,
    String? email,
    bool? notificationEnabled,
  }) {
    return ProfileFormState(
      name: name ?? this.name,
      email: email ?? this.email,
      notificationEnabled: notificationEnabled ?? this.notificationEnabled,
    );
  }
}

class ProfileState {
  final User? user;
  final bool isLoading;
  final String? error;
  final ProfileFormState form;

  const ProfileState({
    this.user,
    this.isLoading = false,
    this.error,
    required this.form,
  });

  ProfileState copyWith({
    User? user,
    bool? isLoading,
    String? error,
    ProfileFormState? form,
  }) {
    return ProfileState(
      user: user ?? this.user,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      form: form ?? this.form,
    );
  }
}

class ProfileNotifier extends StateNotifier<ProfileState> {
  final GetUserProfileUseCase getUserProfileUseCase;
  final UpdateUserProfileUseCase updateUserSettingsUseCase;
  final LogoutUseCase logoutUseCase;
  final Ref ref;

  ProfileNotifier(
    this.getUserProfileUseCase,
    this.updateUserSettingsUseCase,
    this.logoutUseCase,
    this.ref,
  ) : super(ProfileState(form: ProfileFormState()));

  Future<void> init() async {
    if (state.user != null) return; // Prevent re-fetching if data exists
    await fetchUserProfile();
  }

  Future<void> fetchUserProfile() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final user = await getUserProfileUseCase.call();
      state = state.copyWith(
        user: user,
        isLoading: false,
        form: ProfileFormState(
          name: user.name,
          email: user.email,
          notificationEnabled: user.settings?.notificationEnabled,
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateName(String? name) {
    state = state.copyWith(form: state.form.copyWith(name: name));
  }

  void updateEmail(String? email) {
    state = state.copyWith(form: state.form.copyWith(email: email));
  }

  void updateNotificationEnabled(bool? enabled) {
    state = state.copyWith(
      form: state.form.copyWith(notificationEnabled: enabled),
    );
  }

  Future<void> saveProfile(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final request = UserSettingsUpdateRequestModel(
        notificationEnabled: state.form.notificationEnabled,
      );
      // Note: 'name' and 'email' are updated via the mock data source for demonstration purposes.
      // In a real application, a separate API endpoint or a more comprehensive user update endpoint
      // would be required to update these fields if they are part of the core user profile
      // and not just user settings.
      final updatedUser = await updateUserSettingsUseCase.call(
        request: request,
        name: state.form.name,
        email: state.form.email,
      );
      state = state.copyWith(
        user: updatedUser,
        isLoading: false,
        form: ProfileFormState(
          name: updatedUser.name,
          email: updatedUser.email,
          notificationEnabled: updatedUser.settings?.notificationEnabled,
        ),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật hồ sơ thành công!')),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi cập nhật hồ sơ: ${e.toString()}')),
      );
    }
  }

  Future<void> logout(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await logoutUseCase.call();
      state = state.copyWith(isLoading: false);
      context.go(AppRoutes.login); // Assuming you have a login route
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Lỗi đăng xuất: ${e.toString()}')));
    }
  }

  void onBack(BuildContext context) {
    context.go(AppRoutes.profile);
  }
}
