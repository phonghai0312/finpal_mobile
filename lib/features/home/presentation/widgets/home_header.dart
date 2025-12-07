// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/suggestions/presentation/provider/insight/insight_provider.dart';
import 'package:go_router/go_router.dart';

class HomeHeader extends ConsumerWidget {
  final String userName;
  final String totalIncomeText;
  final String totalExpenseText;
  final VoidCallback? onNotificationTap;

  const HomeHeader({
    super.key,
    required this.userName,
    required this.totalIncomeText,
    required this.totalExpenseText,
    this.onNotificationTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final unreadCount = ref.watch(insightsNotifierProvider).insights.length;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: AppColors.bgDarkGreen,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28.r),
          bottomRight: Radius.circular(28.r),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ----- TOP -----
          Padding(
            padding: EdgeInsets.only(
              left: 16.w,
              right: 16.w,
              top: 40.h,
              bottom: 16.h,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// LEFT TEXT
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Xin chào,",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      4.verticalSpace,
                      Text(
                        userName,
                        style: TextStyle(
                          fontSize: 22.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                /// NOTIFICATION BUTTON
                GestureDetector(
                  onTap: () => context.push(AppRoutes.suggestions),
                  child: Stack(
                    children: [
                      Container(
                        width: 48.w,
                        height: 48.w,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.20),
                          borderRadius: BorderRadius.circular(100.r),
                        ),
                        child: Icon(
                          Icons.notifications_none,
                          size: 26.w,
                          color: Colors.white,
                        ),
                      ),
                      if (unreadCount > 0)
                        Positioned(
                          right: 4.w,
                          top: 4.h,
                          child: Container(
                            padding: EdgeInsets.all(4.w),
                            decoration: BoxDecoration(
                              color: AppColors.bgError,
                              shape: BoxShape.circle,
                            ),
                            constraints: BoxConstraints(
                              minWidth: 20.w,
                              minHeight: 20.w,
                            ),
                            child: Center(
                              child: Text(
                                '$unreadCount',
                                style: TextStyle(
                                  color: AppColors.typoWhite,
                                  fontSize: 12.sp,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          /// ----- INCOME / EXPENSE CARD -----
          Padding(
            padding: EdgeInsets.only(left: 14.w, right: 16.w, bottom: 20.h),
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 18.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(
                  color: const Color(0xFF3A8DFF).withOpacity(0.4),
                  width: 1.4,
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _amountItem("Tổng thu", totalIncomeText, Colors.green),
                  _amountItem("Tổng chi", totalExpenseText, Colors.red),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _amountItem(String title, String value, Color color) {
    return Column(
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        6.verticalSpace,
        Text(
          value,
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
