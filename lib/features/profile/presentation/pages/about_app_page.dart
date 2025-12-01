// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../provider/aboutapp/about_app_provider.dart';

class AboutAppPage extends ConsumerWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(aboutAppNotifierProvider);
    final notifier = ref.read(aboutAppNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: 'Về ứng dụng',
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            /// LOGO
            Image.asset(
              'assets/image/logo_finpal.png',
              height: 200.h,
              width: 120.w,
            ),
            SizedBox(height: 16.h),

            /// APP NAME
            Text(
              state.appName,
              style: GoogleFonts.poppins(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.bgDarkGreen,
              ),
            ),

            SizedBox(height: 8.h),

            /// VERSION
            Text(
              'Phiên bản ${state.version}',
              style: GoogleFonts.poppins(
                fontSize: 15.sp,
                color: AppColors.typoBody,
              ),
            ),

            /// BUILD NUMBER
            Text(
              'Build ${state.buildNumber}',
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.typoBody,
              ),
            ),

            SizedBox(height: 24.h),

            /// DESCRIPTION
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
              ),
              child: Text(
                state.description,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  color: AppColors.typoBody,
                  height: 1.4,
                ),
                textAlign: TextAlign.center,
              ),
            ),

            SizedBox(height: 24.h),

            /// FEATURE TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tính năng chính',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bgDarkGreen,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            _buildFeatureItem(context, 'Tự động đồng bộ giao dịch từ Sepay'),
            SizedBox(height: 8.h),
            _buildFeatureItem(context, 'Phân loại thông minh bằng AI Gemini'),
            SizedBox(height: 8.h),
            _buildFeatureItem(context, 'Thống kê và báo cáo chi tiết'),
            SizedBox(height: 8.h),
            _buildFeatureItem(context, 'Gợi ý tài chính cá nhân hóa'),
            SizedBox(height: 8.h),
            _buildFeatureItem(context, 'Quản lý ngân sách theo danh mục'),

            SizedBox(height: 24.h),

            /// CONTACT TITLE
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Liên hệ',
                style: GoogleFonts.poppins(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.bgDarkGreen,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            _buildContactInfo(
              context,
              Icons.email,
              'CEOFinPal@gmail.com',
              () {},
            ),

            SizedBox(height: 8.h),

            _buildContactInfo(context, Icons.language, 'www.FinPal.com', () {}),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(BuildContext context, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(
          Icons.check_circle_outline,
          color: AppColors.bgDarkGreen,
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              color: AppColors.typoBody,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContactInfo(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
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
            Icon(icon, color: AppColors.bgDarkGreen, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.poppins(
                  fontSize: 16.sp,
                  color: AppColors.typoHeading,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
