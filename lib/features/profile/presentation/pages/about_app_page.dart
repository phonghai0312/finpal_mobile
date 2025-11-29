// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class AboutAppPage extends ConsumerWidget {
  const AboutAppPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          'Về ứng dụng',
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/image/logo_finpal.png', // Placeholder for app logo
              height: 120.h,
              width: 120.w,
            ),
            SizedBox(height: 16.h),
            Text(
              'Ví thông minh - FinPal',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              'Phiên bản 1.0.0',
              style: Theme.of(
                context,
              ).textTheme.bodyLarge?.copyWith(color: AppColors.typoBody),
            ),
            Text(
              'Build 20251113',
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
            ),
            SizedBox(height: 24.h),
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bgWhite,
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
              ),
              child: Text(
                'Ví Thông Minh - FinPal là ứng dụng quản lý tài chính cá nhân sử dụng AI để tự động phân loại giao dịch từ Sepay và đưa ra những gợi ý tài chính thông minh, giúp bạn kiểm soát chi tiêu hiệu quả hơn.',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 24.h),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Tính năng chính',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.typoHeading,
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
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Liên hệ',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.typoHeading,
                ),
              ),
            ),
            SizedBox(height: 12.h),
            _buildContactInfo(context, Icons.email, 'CEOFinPal@gmail.com', () {
              // Handle email tap
            }),
            SizedBox(height: 8.h),
            _buildContactInfo(context, Icons.language, 'www.FinPal.com', () {
              // Handle website tap
            }),
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
          color: AppColors.primaryGreen,
          size: 20.sp,
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(
              context,
            ).textTheme.bodyLarge?.copyWith(color: AppColors.typoBody),
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
            Icon(icon, color: AppColors.primaryGreen, size: 24.sp),
            SizedBox(width: 12.w),
            Expanded(
              child: Text(
                text,
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
