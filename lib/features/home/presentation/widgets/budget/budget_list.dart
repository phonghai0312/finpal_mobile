// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import 'package:fridge_to_fork_ai/core/presentation/theme/app_chart_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';

class BudgetList extends ConsumerStatefulWidget {
  const BudgetList({super.key});

  @override
  ConsumerState<BudgetList> createState() => _BudgetListState();
}

class _BudgetListState extends ConsumerState<BudgetList> {
  @override
  void initState() {
    super.initState();

    /// ✅ LUỒNG MỚI: init KHÔNG truyền context
    Future.microtask(() {
      ref.read(budgetNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final budgetState = ref.watch(budgetNotifierProvider);
    final categoryState = ref.watch(categoryNotifierProvider);
    final notifier = ref.read(budgetNotifierProvider.notifier);

    /// ---------------- LOADING ----------------
    if (budgetState.isLoading && budgetState.budgets.isEmpty) {
      return _container(
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    /// ---------------- ERROR ----------------
    if (budgetState.errorMessage != null && budgetState.budgets.isEmpty) {
      return _container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 40.sp, color: Colors.red[300]),
            SizedBox(height: 8.h),
            Text(
              'Không thể tải ngân sách',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.red[700],
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              budgetState.errorMessage!,
              style: TextStyle(fontSize: 12.sp, color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 12.h),
            ElevatedButton(
              onPressed: () => notifier.init(context),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    /// ---------------- EMPTY ----------------
    if (budgetState.budgets.isEmpty) {
      return _container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.money_off, size: 40.sp, color: Colors.grey[400]),
            SizedBox(height: 8.h),
            Text(
              'Chưa có ngân sách',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
          ],
        ),
      );
    }

    /// ---------------- LIST ----------------
    return SizedBox(
      height: 132.h,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        itemCount: budgetState.budgets.length,
        separatorBuilder: (_, __) => SizedBox(width: 12.w),
        itemBuilder: (context, index) {
          final budget = budgetState.budgets[index];
          final color =
              AppChartColors.colors[index % AppChartColors.colors.length];

          final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

          /// lấy tên danh mục (fallback)
          String? categoryName;
          for (final c in categoryState.categories) {
            if (c.id == budget.categoryId) {
              categoryName = c.displayName;
              break;
            }
          }

          final displayName =
              categoryName ??
              (budget.categoryName.isNotEmpty
                  ? budget.categoryName
                  : 'Không xác định');

          return Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14.r),
            child: InkWell(
              borderRadius: BorderRadius.circular(14.r),
              hoverColor: AppColors.primaryGreen.withOpacity(0.06),
              splashColor: AppColors.primaryGreen.withOpacity(0.12),

              /// ✅ LUỒNG MỚI
              onTap: () {
                notifier.onBudgetSelected(context, budget);
              },

              child: Ink(
                width: 150.w,
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: Colors.grey.withOpacity(0.12)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 32.w,
                          height: 32.w,
                          decoration: BoxDecoration(
                            color: color.withOpacity(0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            _iconFromName(displayName),
                            size: 18.sp,
                            color: color,
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: Text(
                            displayName,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    Text(
                      formatter.format(budget.amount),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _container({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 20.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: child,
    );
  }

  /// =======================================================
  /// ICON MAPPING (FIX ĐẦY ĐỦ RETURN)
  /// =======================================================

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
    if (name.contains('mua sắm') ||
        name.contains('shop') ||
        name.contains('mua')) {
      return Icons.shopping_bag;
    }
    if (name.contains('thu nhập') ||
        name.contains('lương') ||
        name.contains('salary') ||
        name.contains('tiền')) {
      return Icons.attach_money;
    }
    if (name.contains('xe') ||
        name.contains('car') ||
        name.contains('di chuyển')) {
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
    if (name.contains('yêu') ||
        name.contains('love') ||
        name.contains('tình')) {
      return Icons.favorite;
    }
    if (name.contains('cafe') ||
        name.contains('coffee') ||
        name.contains('trà')) {
      return Icons.local_cafe;
    }
    if (name.contains('nước') || name.contains('water')) {
      return Icons.water_drop;
    }

    /// ✅ BẮT BUỘC PHẢI CÓ
    return fallback;
  }
}
