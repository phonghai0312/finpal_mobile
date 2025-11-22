import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:go_router/go_router.dart';

class SuggestionsPage extends ConsumerWidget {
  const SuggestionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        backgroundColor: AppColors.bgWhite,
        elevation: 0,
        title: Text(
          'Gợi ý tài chính',
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
            Row(
              children: [
                Expanded(
                  child: _buildSuggestionCard(
                    context,
                    icon: Icons.warning_amber_rounded,
                    iconColor: AppColors.bgWarning,
                    title: 'Cảnh báo quan trọng!',
                    description: 'Chi tiêu cho cà phê tăng 35% so với tháng trước. Bạn đã chi 300.000đ trong tháng này',
                    buttonText: 'Xem chi tiết & đặt hạn mức',
                    onTap: () {},
                    cardColor: AppColors.bgWarning.withOpacity(0.1),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: _buildSuggestionCard(
                    context,
                    icon: Icons.lightbulb_outline,
                    iconColor: AppColors.primaryGreen,
                    title: 'Phân tích tự động',
                    description: 'AI đã quét & phân loại 125 giao dịch từ SMS ngân hàng tháng này',
                    buttonText: 'Xem chi tiết',
                    onTap: () => context.go(AppRoutes.stats),
                    cardColor: AppColors.primaryGreen.withOpacity(0.1),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Các gợi ý khác',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 16.h),
            _buildLargeSuggestionCard(
              context,
              icon: Icons.arrow_upward_rounded,
              iconColor: AppColors.primaryGreen,
              title: 'Tiết kiệm tốt hơn tháng trước',
              description: 'Bạn đã tiết kiệm được 12.500.000đ trong tháng này, tăng 8.5% so với tháng trước',
              onTap: () {},
              cardColor: AppColors.primaryGreen.withOpacity(0.1),
            ),
            SizedBox(height: 16.h),
            _buildLargeSuggestionCard(
              context,
              icon: Icons.money,
              iconColor: AppColors.typoPrimary,
              title: 'Đề xuất ngân sách',
              description: 'Dựa trên thói quen chi tiêu, bạn nên đặt ngân sách 1.500.000đ cho ăn uống tháng sau',
              onTap: () {},
              cardColor: AppColors.lightRed.withOpacity(0.1),
            ),
            SizedBox(height: 16.h),
            _buildLargeSuggestionCard(
              context,
              icon: Icons.emoji_objects_outlined,
              iconColor: AppColors.lightRed,
              title: 'Mẹo tiết kiệm',
              description: 'Thay vì mua cà phê mỗi ngày, bạn có thể tiết kiệm 200.000đ/tháng nếu tự pha tại nhà 3...',
              onTap: () {},
              cardColor: AppColors.lightRed.withOpacity(0.1),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestionCard(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String description,
        required String buttonText,
        required VoidCallback onTap,
        required Color cardColor,
      }) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: iconColor.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: iconColor, size: 30.sp),
          SizedBox(height: 8.h),
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
              color: AppColors.typoHeading,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            description,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: AppColors.typoBody,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 12.h),
          GestureDetector(
            onTap: onTap,
            child: Text(
              buttonText,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLargeSuggestionCard(
      BuildContext context, {
        required IconData icon,
        required Color iconColor,
        required String title,
        required String description,
        required VoidCallback onTap,
        required Color cardColor,
      }) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: iconColor.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: iconColor, size: 36.sp),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.typoHeading,
                  ),
                ),
                SizedBox(height: 4.h),
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.typoBody,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
          SizedBox(width: 16.w),
          GestureDetector(
            onTap: onTap,
            child: Text(
              'Xem chi tiết',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: iconColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
