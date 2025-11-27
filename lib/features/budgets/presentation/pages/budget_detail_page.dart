import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_chart_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_detail_notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetDetailPage extends ConsumerWidget {
  final String budgetId;

  const BudgetDetailPage({super.key, required this.budgetId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final budgetDetailState = ref.watch(budgetDetailNotifierProvider(budgetId));

    ref.listen<BudgetDetailState>(budgetDetailNotifierProvider(budgetId), (
      previous,
      next,
    ) {
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${next.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.budget == null && previous?.budget != null && !next.isLoading) {
        // Budget was deleted, pop back to previous screen
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Ngân sách đã được xóa thành công!'),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết ngân sách'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed:
                budgetDetailState.isLoading || budgetDetailState.budget == null
                ? null
                : () {
                    context.push(AppRoutes.budgetForm, extra: budgetId);
                  },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed:
                budgetDetailState.isLoading || budgetDetailState.budget == null
                ? null
                : () async {
                    await ref
                        .read(budgetDetailNotifierProvider(budgetId).notifier)
                        .deleteBudget(budgetId);
                  },
          ),
        ],
      ),
      body: budgetDetailState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : budgetDetailState.errorMessage != null
          ? Center(child: Text('Lỗi: ${budgetDetailState.errorMessage}'))
          : budgetDetailState.budget == null
          ? const Center(child: Text('Không tìm thấy ngân sách'))
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    budgetDetailState.budget!.categoryName,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.typoHeading,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'ID: ${budgetDetailState.budget!.id}',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                  ),
                  SizedBox(height: 16.h),
                  _buildInfoRow(
                    context,
                    'Hạn mức',
                    NumberFormat.currency(
                      locale: 'vi_VN',
                      symbol: '₫',
                    ).format(budgetDetailState.budget!.amount),
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    context,
                    'Kỳ hạn',
                    budgetDetailState.budget!.period == 'monthly'
                        ? 'Hàng tháng'
                        : 'Hàng tuần',
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    context,
                    'Ngày bắt đầu',
                    DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        budgetDetailState.budget!.startDate * 1000,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    context,
                    'Ngày kết thúc',
                    DateFormat('dd/MM/yyyy').format(
                      DateTime.fromMillisecondsSinceEpoch(
                        budgetDetailState.budget!.endDate * 1000,
                      ),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  _buildInfoRow(
                    context,
                    'Ngưỡng cảnh báo',
                    '${budgetDetailState.budget!.alertThreshold.toInt()}%',
                  ),
                  SizedBox(height: 24.h),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        // TODO: Implement edit functionality
                      },
                      child: const Text('Chỉnh sửa ngân sách'),
                    ),
                  ),
                  SizedBox(height: 12.h),
                  Center(
                    child: OutlinedButton(
                      onPressed: () {
                        // TODO: Implement delete functionality
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                      ),
                      child: const Text('Xóa ngân sách'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
            color: AppColors.typoHeading,
          ),
        ),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.bodyLarge?.copyWith(color: AppColors.typoBody),
        ),
      ],
    );
  }
}
