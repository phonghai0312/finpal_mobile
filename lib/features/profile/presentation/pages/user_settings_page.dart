// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/usersetting/user_setting_provider.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';

class UserSettingsPage extends ConsumerWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSettingsNotifierProvider);
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: HeaderWithBack(
        title: "Cài đặt",
        onBack: () => Navigator.pop(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===================================
            /// SECTION: CÀI ĐẶT CHUNG
            /// ===================================
            Text(
              "CÀI ĐẶT CHUNG",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 12.h),

            _settingItem(
              context,
              icon: Icons.language,
              title: "Ngôn ngữ",
              subtitle: state.language,
              onTap: notifier.openLanguage,
            ),

            _settingItem(
              context,
              icon: Icons.attach_money,
              title: "Đơn vị tiền tệ",
              subtitle: state.currency,
              onTap: notifier.openCurrency,
            ),

            _settingItem(
              context,
              icon: Icons.access_time,
              title: "Múi giờ",
              subtitle: state.timezone,
              onTap: notifier.openTimezone,
            ),

            SizedBox(height: 24.h),

            /// ===================================
            /// SECTION: THÔNG BÁO
            /// ===================================
            Text(
              "THÔNG BÁO",
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 12.h),

            // ===== Push Notification (new transaction)
            _toggleItem(
              context,
              title: "Thông báo push",
              subtitle: "Nhận thông báo giao dịch mới",
              value: state.pushNewTransaction,
              onChanged: notifier.togglePushNewTransaction,
            ),

            _toggleItem(
              context,
              title: "Thông báo gợi ý tài chính",
              subtitle: "Nhận gợi ý từ AI hàng tuần",
              value: state.pushFinanceSuggestion,
              onChanged: notifier.togglePushFinanceSuggestion,
            ),

            _toggleItem(
              context,
              title: "Báo cáo tháng",
              subtitle: "Báo cáo chi tiêu cuối tháng",
              value: state.pushMonthlyReport,
              onChanged: notifier.togglePushMonthlyReport,
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// UI COMPONENT: Setting Item (Language, Currency...)
  /// ============================================
  Widget _settingItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 10.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.bgGray.withOpacity(0.4)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryGreen, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoHeading,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: AppColors.typoBody),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              size: 18.sp,
              color: AppColors.typoBody,
            ),
          ],
        ),
      ),
    );
  }

  /// ============================================
  /// UI COMPONENT: Toggle Item
  /// ============================================
  Widget _toggleItem(
    BuildContext context, {
    required String title,
    required String subtitle,
    required bool value,
    required Function(bool) onChanged,
  }) {
    return Container(
      margin: EdgeInsets.only(bottom: 14.h),
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.bgGray.withOpacity(0.4)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.typoHeading,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: Theme.of(
                    context,
                  ).textTheme.bodySmall?.copyWith(color: AppColors.typoBody),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            activeColor: AppColors.primaryGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
