// ignore_for_file: use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:finpal/core/presentation/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/domain/entities/user.dart';
import '../../../../auth/presentation/provider/auth/auth_provider.dart';
import '../../../domain/usecases/get_user_profile.dart';
import '../../../domain/usecases/logout.dart';
import '../../../domain/usecases/update_user_profile.dart';
import 'profile_provider.dart';

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
  final UpdateUserProfileUseCase updateUserProfile;
  final Ref ref;
  final ImagePicker _imagePicker = ImagePicker();

  ProfileNotifier(
    this.getUserProfile,
    this.logoutUseCase,
    this.updateUserProfile,
    this.ref,
  ) : super(const ProfileState());

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
      
      // Nếu avatarUrl là path (không phải URL đầy đủ), lấy public URL
      User? updatedUser = user;
      if (user.avatarUrl != null && 
          user.avatarUrl!.isNotEmpty && 
          !user.avatarUrl!.startsWith('http')) {
        try {
          final dataSource = ref.read(profileRemoteDataSourceProvider);
          final publicUrlResponse = await dataSource.getPublicUrl(user.avatarUrl!);
          updatedUser = User(
            id: user.id,
            email: user.email,
            phone: user.phone,
            name: user.name,
            totalIncome: user.totalIncome,
            totalExpense: user.totalExpense,
            avatarUrl: publicUrlResponse.url,
            settings: user.settings,
            createdAt: user.createdAt,
            updatedAt: user.updatedAt,
          );
        } catch (e) {
          // Nếu lỗi khi lấy public URL, vẫn dùng user gốc
          print('Error getting public URL: $e');
        }
      }
      
      state = state.copyWith(user: updatedUser, isLoading: false);
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

  /// -------------------------------------
  /// UPLOAD AVATAR
  /// -------------------------------------
  Future<void> showImageSourceDialog(BuildContext context) async {
    final result = await showModalBottomSheet<ImageSource>(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                SizedBox(height: 12),
                ListTile(
                  leading: Icon(
                    Icons.photo_library,
                    color: AppColors.bgDarkGreen,
                  ),
                  title: Text('Chọn ảnh từ máy'),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.gallery),
                ),
                ListTile(
                  leading: Icon(Icons.camera_alt, color: AppColors.bgDarkGreen),
                  title: Text('Chụp ảnh'),
                  onTap: () => Navigator.pop(sheetContext, ImageSource.camera),
                ),
                SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );

    if (result != null) {
      await _pickAndUploadImage(context, result);
    }
  }

  Future<void> _pickAndUploadImage(
    BuildContext context,
    ImageSource source,
  ) async {
    try {
      state = state.copyWith(isLoading: true);

      final XFile? pickedFile = await _imagePicker.pickImage(
        source: source,
        imageQuality: 85,
        maxWidth: 1024,
        maxHeight: 1024,
      );

      if (pickedFile == null) {
        state = state.copyWith(isLoading: false);
        return;
      }

      final file = File(pickedFile.path);
      final fileName = pickedFile.name;

      // Hiển thị dialog xác nhận
      final shouldUpload = await showDialog<bool>(
        context: context,
        builder: (dialogContext) {
          return AlertDialog(
            title: Text('Xác nhận'),
            content: Text('Bạn có muốn tải ảnh này lên không?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, false),
                child: Text('Hủy'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(dialogContext, true),
                child: Text('Xác nhận'),
              ),
            ],
          );
        },
      );

      if (shouldUpload != true) {
        state = state.copyWith(isLoading: false);
        return;
      }

      // Lấy presigned URL
      final dataSource = ref.read(profileRemoteDataSourceProvider);
      final presignedResponse = await dataSource.getPresignedUrl(fileName);

      // Upload file lên presigned URL
      await _uploadFileToPresignedUrl(file, presignedResponse.url);

      // Lấy avatarUrl từ path (tên file đã được xử lý)
      // Hoặc có thể dùng URL đầy đủ tùy vào backend yêu cầu
      final avatarUrl = presignedResponse.path;

      // Cập nhật avatarUrl trong profile thông qua API
      final updatedUser = await updateUserProfile.call(avatarUrl: avatarUrl);

      state = state.copyWith(user: updatedUser, isLoading: false);

      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tải ảnh lên thành công'),
            backgroundColor: AppColors.bgDarkGreen,
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (e) {
      state = state.copyWith(isLoading: false);
      _handleError(context, e);
    }
  }

  Future<void> _uploadFileToPresignedUrl(File file, String presignedUrl) async {
    final dio = Dio();
    final fileBytes = await file.readAsBytes();

    await dio.put(
      presignedUrl,
      data: fileBytes,
      options: Options(headers: {'Content-Type': 'image/jpeg'}),
    );
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
