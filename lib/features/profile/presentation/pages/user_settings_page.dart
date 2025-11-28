import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_provider.dart';
import 'package:go_router/go_router.dart';

class UserSettingsPage extends ConsumerStatefulWidget {
  const UserSettingsPage({super.key});

  @override
  ConsumerState<UserSettingsPage> createState() => _UserSettingsPageState();
}

class _UserSettingsPageState extends ConsumerState<UserSettingsPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: AppColors.typoHeading,
            size: 24.sp,
          ),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Cài đặt',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: AppColors.typoHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CÀI ĐẶT CHUNG',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.typoBody,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            _buildSettingsMenuItem(
              context,
              icon: Icons.language,
              label: 'Ngôn ngữ',
              value: profileState.user?.settings?.language == 'vi'
                  ? 'Tiếng Việt'
                  : 'English',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chức năng đổi ngôn ngữ chưa được triển khai.',
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),
            _buildSettingsMenuItem(
              context,
              icon: Icons.currency_exchange,
              label: 'Đơn vị tiền tệ',
              value: profileState.user?.settings?.currency ?? 'N/A',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chức năng đổi đơn vị tiền tệ chưa được triển khai.',
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 8.h),
            _buildSettingsMenuItem(
              context,
              icon: Icons.access_time,
              label: 'Múi giờ',
              value: profileState.user?.settings?.timezone ?? 'N/A',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      'Chức năng đổi múi giờ chưa được triển khai.',
                    ),
                  ),
                );
              },
            ),
            SizedBox(height: 24.h),
            Text(
              'THÔNG BÁO',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: AppColors.typoBody,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 12.h),
            _buildNotificationSwitch(
              context,
              'Thông báo push',
              'Nhận thông báo giao dịch mới',
              profileState.user?.settings?.notificationEnabled ?? false,
              (value) => notifier.updateNotificationEnabled(value),
            ),
            SizedBox(height: 8.h),
            _buildNotificationSwitch(
              context,
              'Thông báo gợi ý tài chính',
              'Nhận gợi ý từ AI hàng tuần',
              true, // Placeholder for financial tips notification
              (value) {},
            ),
            SizedBox(height: 8.h),
            _buildNotificationSwitch(
              context,
              'Báo cáo tháng',
              'Báo cáo chi tiêu cuối tháng',
              true, // Placeholder for monthly report notification
              (value) {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenuItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
            Text(
              value,
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.typoBody),
            ),
            SizedBox(width: 8.w),
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

  Widget _buildNotificationSwitch(
    BuildContext context,
    String title,
    String subtitle,
    bool value,
    Function(bool) onChanged,
  ) {
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
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: AppColors.typoHeading,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
              ),
            ],
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryGreen,
          ),
        ],
      ),
    );
  }
}
