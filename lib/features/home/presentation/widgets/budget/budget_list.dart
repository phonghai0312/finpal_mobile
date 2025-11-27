import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_chart_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';

class BudgetList extends StatelessWidget {
  final List<Budget> budgets;

  const BudgetList({super.key, required this.budgets});

  @override
  Widget build(BuildContext context) {
    if (budgets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min, // 👈 tránh cao dư
          children: [
            Icon(Icons.money_off, size: 48.sp, color: Colors.grey[400]),
            SizedBox(height: 12.h),
            Text(
              'Chưa có ngân sách nào',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ngân sách',
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: AppColors.typoHeading,
          ),
        ),
        SizedBox(height: 16.h),
        SizedBox(
          // 👇 tăng nhẹ chiều cao list, tránh card bị chật
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: budgets.length,
            itemBuilder: (context, index) {
              final budget = budgets[index];
              final color =
                  AppChartColors.colors[index % AppChartColors.colors.length];
              final spentAmount = 3000000.0; // Mock
              final progress = (spentAmount / budget.amount).clamp(0.0, 1.0);
              final formatter = NumberFormat.currency(
                locale: 'vi_VN',
                symbol: '₫',
              );

              return GestureDetector(
                onTap: () {
                  // Navigate to BudgetDetailPage
                  context.push('${AppRoutes.budgetDetail}/${budget.id}');
                },
                child: Container(
                  width: 180.w,
                  margin: EdgeInsets.only(right: 16.w),
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    color: AppColors.bgWhite,
                    borderRadius: BorderRadius.circular(16.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween, // 👈 dàn đều trên–dưới
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 40.w,
                            height: 40.w,
                            decoration: BoxDecoration(
                              color: color.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.fastfood, // Placeholder icon
                              color: color,
                              size: 24.sp,
                            ),
                          ),
                          SizedBox(width: 8.w),
                          Expanded(
                            child: Text(
                              budget.categoryName,
                              maxLines: 1, // 👈 hạn chế xuống nhiều dòng
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.typoHeading,
                                  ),
                            ),
                          ),
                        ],
                      ),
                      // bỏ bớt SizedBox cao quá, để column tự co lại
                      Text(
                        formatter.format(budget.amount),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.typoBody,
                        ),
                      ),
                      Text(
                        'Đã chi ${formatter.format(spentAmount)}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.typoBody,
                        ),
                      ),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: Colors.grey[200],
                        valueColor: AlwaysStoppedAnimation<Color>(color),
                        minHeight: 6.h,
                        borderRadius: BorderRadius.circular(3.r),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
