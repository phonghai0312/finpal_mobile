// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_provider.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  // Removed TextEditingControllers as fields are now read-only

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).init();
    });
  }

  // Removed didUpdateWidget as controllers are no longer managed here

  @override
  void dispose() {
    // No controllers to dispose of now
    super.dispose();
  }

  // Removed _updateControllers method

  Widget _buildProfileMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 24.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: AppColors.typoHeading,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.typoBody,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context) {
    return Container(
      height: 80.h,
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, -2),
          ),
        ],
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24.r),
          topRight: Radius.circular(24.r),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    if (profileState.isLoading && profileState.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(
              bottom: 80.h,
            ), // Space for bottom navigation
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 24.h,
                    horizontal: 16.w,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.primaryGreen,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(24.r),
                      bottomRight: Radius.circular(24.r),
                    ),
                  ),
                  child: Column(
                    children: [
                      SizedBox(height: 24.h), // For status bar
                      Text(
                        'Cá nhân',
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.typoWhite,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 24.h),
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppColors.bgWhite.withOpacity(0.2),
                        backgroundImage: NetworkImage(
                          profileState.user?.avatarUrl ??
                              'https://www.gravatar.com/avatar/?d=mp',
                        ),
                      ),
                      SizedBox(height: 12.h),
                      Text(
                        profileState.user?.name ?? 'Người dùng',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.typoWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),
                      Text(
                        'ID: ${profileState.user?.id ?? 'N/A'}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.typoWhite.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 24.h),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.person_outline,
                  label: 'Chỉnh sửa thông tin cá nhân',
                  onTap: () {
                    context.go(AppRoutes.editProfile);
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.settings_outlined,
                  label: 'Cài đặt',
                  onTap: () {
                    context.push(AppRoutes.userSettings);
                  },
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    'THÔNG TIN',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.typoBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.info_outline,
                  label: 'Về ứng dụng',
                  onTap: () {
                    context.push(AppRoutes.aboutApp);
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.help_outline,
                  label: 'Trợ giúp',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Chức năng trợ giúp chưa được triển khai.',
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 8.h),
                _buildProfileMenuItem(
                  context,
                  icon: Icons.security,
                  label: 'Chính sách bảo mật',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          'Chức năng chính sách bảo mật chưa được triển khai.',
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 24.h),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: OutlinedButton(
                    onPressed: profileState.isLoading
                        ? null
                        : () => notifier.logout(context),
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.bgError),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      minimumSize: Size(double.infinity, 50.h),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.logout,
                          color: AppColors.bgError,
                          size: 24.sp,
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          'Đăng xuất',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.bgError,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: _buildBottomNavigationBar(context),
          // ),
        ],
      ),
    );
  }
}
