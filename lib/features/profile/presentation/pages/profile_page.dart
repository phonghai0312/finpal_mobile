// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_provider.dart';
import '../../../../../core/presentation/theme/app_colors.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    /// Gọi init() sau frame đầu tiên
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).init();
    });
  }

  Widget _menuItem({
    required BuildContext context,
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

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    /// Loading lần đầu — chưa có user
    if (state.isLoading && state.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.only(bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Header xanh
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    vertical: 36.h,
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
                      SizedBox(height: 24.h),
                      Text(
                        "Cá nhân",
                        style: Theme.of(context).textTheme.headlineSmall
                            ?.copyWith(
                              color: AppColors.typoWhite,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      SizedBox(height: 24.h),

                      /// Avatar
                      CircleAvatar(
                        radius: 50.r,
                        backgroundColor: AppColors.bgWhite.withOpacity(0.2),
                        backgroundImage: NetworkImage(
                          state.user?.avatarUrl ??
                              "https://www.gravatar.com/avatar/?d=mp",
                        ),
                      ),

                      SizedBox(height: 12.h),

                      /// User name
                      Text(
                        state.user?.name ?? "Người dùng",
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          color: AppColors.typoWhite,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 4.h),

                      /// User ID
                      Text(
                        "ID: ${state.user?.id ?? "N/A"}",
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.typoWhite.withOpacity(0.7),
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24.h),

                /// Edit profile
                _menuItem(
                  context: context,
                  icon: Icons.person_outline,
                  label: "Chỉnh sửa thông tin cá nhân",
                  onTap: () => notifier.goToEditProfile(context),
                ),

                SizedBox(height: 8.h),

                /// Settings
                _menuItem(
                  context: context,
                  icon: Icons.settings_outlined,
                  label: "Cài đặt",
                  onTap: () => notifier.goToSettings(context),
                ),

                SizedBox(height: 24.h),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Text(
                    "THÔNG TIN",
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: AppColors.typoBody,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

                SizedBox(height: 12.h),

                _menuItem(
                  context: context,
                  icon: Icons.info_outline,
                  label: "Về ứng dụng",
                  onTap: () => notifier.goToAboutApp(context),
                ),

                SizedBox(height: 8.h),

                _menuItem(
                  context: context,
                  icon: Icons.help_outline,
                  label: "Trợ giúp",
                  onTap: () => notifier.goToHelpSupport(context),
                ),

                SizedBox(height: 8.h),

                _menuItem(
                  context: context,
                  icon: Icons.security,
                  label: "Chính sách bảo mật",
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Tính năng chính sách bảo mật chưa triển khai.",
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 24.h),

                /// Logout
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: OutlinedButton(
                    onPressed: state.isLoading
                        ? null
                        : () => notifier.logout(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.bgError),
                      padding: EdgeInsets.symmetric(vertical: 16.h),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
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
                          "Đăng xuất",
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(
                                color: AppColors.bgError,
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
        ],
      ),
    );
  }
}
