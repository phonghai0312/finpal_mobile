import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile_provider.dart';
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

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    if (profileState.isLoading && profileState.user == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: 'Hồ sơ cá nhân',
        onBack: () => notifier.onBack(context)
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.r,
                    backgroundImage: NetworkImage(
                      profileState.user?.avatarUrl ?? 'https://www.gravatar.com/avatar/?d=mp',
                    ),
                    backgroundColor: AppColors.bgGray.withOpacity(0.2),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    profileState.user?.name ?? 'Người dùng',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.typoHeading,
                        ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    profileState.user?.email ?? profileState.user?.phone ?? '',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: AppColors.typoBody,
                        ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h),
            Text(
              'Thông tin cá nhân',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.typoHeading,
                  ),
            ),
            SizedBox(height: 12.h),
            _buildInfoRow(context, 'Tên', profileState.user?.name ?? 'N/A'),
            SizedBox(height: 8.h),
            _buildInfoRow(context, 'Email', profileState.user?.email ?? 'N/A'),
            SizedBox(height: 8.h),
            _buildNotificationSwitch(context, profileState.user?.settings?.notificationEnabled ?? false),
            SizedBox(height: 32.h),
            ElevatedButton(
              onPressed: () {
                context.push(AppRoutes.editProfile);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 4,
                shadowColor: AppColors.primaryGreen.withOpacity(0.3),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text(
                'Chỉnh sửa thông tin cá nhân',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.typoWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: () {
                // TODO: Implement Change Password functionality
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Chức năng đổi mật khẩu chưa được triển khai.')),
                );
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text(
                'Đổi mật khẩu',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.typoBody,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: profileState.isLoading ? null : () => notifier.logout(context),
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.bgError),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text(
                'Đăng xuất',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.bgError,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.typoBody,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.typoHeading,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationSwitch(BuildContext context, bool isEnabled) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Bật thông báo',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.typoBody,
                  fontWeight: FontWeight.w600,
                ),
          ),
          Switch(
            value: isEnabled,
            onChanged: null, // Read-only
            activeColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}
