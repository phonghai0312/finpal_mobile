// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';
import '../provider/usersetting/user_setting_provider.dart';

class UserSettingsPage extends ConsumerWidget {
  const UserSettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(userSettingsNotifierProvider);
    final notifier = ref.read(userSettingsNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: "Cài đặt",
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ================================
            /// SECTION: CÀI ĐẶT CHUNG
            /// ================================
            Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
              child: Text(
                "CÀI ĐẶT CHUNG",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoHeading,
                ),
              ),
            ),

            _settingItem(
              context: context,
              icon: Icons.language,
              title: "Ngôn ngữ",
              subtitle: state.language,
              onTap: notifier.openLanguage,
            ),

            _settingItem(
              context: context,
              icon: Icons.attach_money,
              title: "Đơn vị tiền tệ",
              subtitle: state.currency,
              onTap: notifier.openCurrency,
            ),

            _settingItem(
              context: context,
              icon: Icons.access_time,
              title: "Múi giờ",
              subtitle: state.timezone,
              onTap: notifier.openTimezone,
            ),

            SizedBox(height: 24.h),

            /// ================================
            /// SECTION: THÔNG BÁO
            /// ================================
            Padding(
              padding: EdgeInsets.only(left: 4.w, bottom: 10.h),
              child: Text(
                "THÔNG BÁO",
                style: GoogleFonts.poppins(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoHeading,
                ),
              ),
            ),

            _toggleItem(
              context: context,
              title: "Thông báo push",
              subtitle: "Nhận thông báo giao dịch mới",
              value: state.pushNewTransaction,
              onChanged: notifier.togglePushNewTransaction,
            ),

            _toggleItem(
              context: context,
              title: "Thông báo gợi ý tài chính",
              subtitle: "Nhận gợi ý từ AI hàng tuần",
              value: state.pushFinanceSuggestion,
              onChanged: notifier.togglePushFinanceSuggestion,
            ),

            _toggleItem(
              context: context,
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

  /// =====================================
  /// SETTING ITEM STYLE (Language, Timezone, Currency...)
  /// =====================================
  Widget _settingItem({
    required BuildContext context,
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(bottom: 12.h),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(14.r),
          border: Border.all(color: AppColors.bgGray.withOpacity(0.35)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.bgDarkGreen, size: 24.sp),
            SizedBox(width: 12.w),

            /// Title + Subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: AppColors.typoHeading,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.typoBody,
                    ),
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

  /// =====================================
  /// TOGGLE ITEM STYLE
  /// =====================================
  Widget _toggleItem({
    required BuildContext context,
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
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: AppColors.bgGray.withOpacity(0.35)),
      ),
      child: Row(
        children: [
          /// Text side
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                    color: AppColors.typoHeading,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  subtitle,
                  style: GoogleFonts.poppins(
                    fontSize: 14.sp,
                    color: AppColors.typoBody,
                  ),
                ),
              ],
            ),
          ),

          /// Switch
          Switch(
            value: value,
            activeColor: AppColors.bgDarkGreen,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}
