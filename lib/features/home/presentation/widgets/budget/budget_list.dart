// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_chart_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetList extends ConsumerStatefulWidget {
  const BudgetList({super.key});

  @override
  ConsumerState<BudgetList> createState() => _BudgetListState();
}

class _BudgetListState extends ConsumerState<BudgetList> {
  @override
  void initState() {
    super.initState();
    // Fetch budgets when widget is first built
    Future.microtask(() {
      ref.read(budgetNotifierProvider.notifier).fetchBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetNotifierProvider);
    final categoryState = ref.watch(categoryNotifierProvider);

    // Show loading state
    if (budgetState.isLoading && budgetState.budgets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    // Show error state
    if (budgetState.errorMessage != null && budgetState.budgets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 48.sp, color: Colors.red[300]),
            SizedBox(height: 12.h),
            Text(
              'Lỗi tải ngân sách',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 8.h),
            Text(
              budgetState.errorMessage ?? 'Đã xảy ra lỗi',
              style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () {
                ref.read(budgetNotifierProvider.notifier).fetchBudgets();
              },
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    // Show empty state
    if (budgetState.budgets.isEmpty) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
          height: 190.h,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: budgetState.budgets.length,
            itemBuilder: (context, index) {
              final budget = budgetState.budgets[index];
              final color =
                  AppChartColors.colors[index % AppChartColors.colors.length];
              final spentAmount = budget.spentAmount;
              final amount = budget.amount <= 0 ? 1 : budget.amount;
              final progress = (spentAmount / amount).clamp(0.0, 1.0);
              final formatter = NumberFormat.currency(
                locale: 'vi_VN',
                symbol: '₫',
              );

              // Find category from categoryState to get name
              String? categoryName;
              for (final category in categoryState.categories) {
                if (category.id == budget.categoryId) {
                  categoryName = category.displayName;
                  break;
                }
              }
              // Fallback to budget.categoryName nếu không tìm thấy
              final displayName =
                  categoryName ??
                  (budget.categoryName.isNotEmpty
                      ? budget.categoryName
                      : 'Không xác định');

              return Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(16.r),
                  onTap: () {
                    if (budget.id.isEmpty) return;
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                _iconFromName(displayName),
                                color: color,
                                size: 24.sp,
                              ),
                            ),
                            SizedBox(width: 8.w),
                            Expanded(
                              child: Text(
                                displayName,
                                maxLines: 1,
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
                          value: progress.isNaN ? 0 : progress,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation<Color>(color),
                          minHeight: 6.h,
                          borderRadius: BorderRadius.circular(3.r),
                        ),
                      ],
                    ),
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

IconData _iconFromName(String? categoryName) {
  const fallback = Icons.category;
  if (categoryName == null) return fallback;

  final name = categoryName.toLowerCase();

  if (name.contains('ăn') ||
      name.contains('food') ||
      name.contains('ăn uống') ||
      name.contains('meal')) {
    return Icons.fastfood;
  }
  if (name.contains('mua sắm') || name.contains('shop') || name.contains('mua')) {
    return Icons.shopping_bag;
  }
  if (name.contains('thu nhập') ||
      name.contains('lương') ||
      name.contains('salary') ||
      name.contains('tiền')) {
    return Icons.attach_money;
  }
  if (name.contains('xe') || name.contains('car') || name.contains('di chuyển')) {
    return Icons.directions_car;
  }
  if (name.contains('sức khỏe') ||
      name.contains('health') ||
      name.contains('y tế') ||
      name.contains('medical')) {
    return Icons.medical_services;
  }
  if (name.contains('nhà') || name.contains('home')) {
    return Icons.home;
  }
  if (name.contains('yêu') || name.contains('love') || name.contains('tình')) {
    return Icons.favorite;
  }
  if (name.contains('cafe') || name.contains('coffee') || name.contains('trà')) {
    return Icons.local_cafe;
  }
  if (name.contains('nước') || name.contains('water')) {
    return Icons.water_drop;
  }
  if (name.contains('điện') || name.contains('electric') || name.contains('power')) {
    return Icons.flash_on;
  }

  return fallback;
}
