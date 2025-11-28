import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
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
    final notifier = ref.read(budgetDetailNotifierProvider(budgetId).notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: const Text('Chi tiết ngân sách'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: budgetDetailState.budget == null
                ? null
                : () => notifier.goToEdit(context),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: budgetDetailState.budget == null
                ? null
                : () => _confirmDelete(context, notifier),
          ),
        ],
      ),
      body: budgetDetailState.isLoading && budgetDetailState.budget == null
          ? const Center(child: CircularProgressIndicator())
          : budgetDetailState.errorMessage != null &&
                  budgetDetailState.budget == null
              ? _ErrorView(
                  message: budgetDetailState.errorMessage!,
                  onRetry: () =>
                      ref.refresh(budgetDetailNotifierProvider(budgetId)),
                )
              : budgetDetailState.budget == null
                  ? const _EmptyView()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _BudgetHeroCard(budget: budgetDetailState.budget!),
                          SizedBox(height: 16.h),
                          _BudgetInfoCard(budget: budgetDetailState.budget!),
                          SizedBox(height: 16.h),
                          _TimelineCard(budget: budgetDetailState.budget!),
                          SizedBox(height: 24.h),
                          _ActionButtons(
                            onEdit: () => notifier.goToEdit(context),
                            onDelete: () => _confirmDelete(context, notifier),
                          ),
                        ],
                      ),
                    ),
    );
  }

  Future<void> _confirmDelete(
    BuildContext context,
    BudgetDetailNotifier notifier,
  ) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa ngân sách'),
        content: const Text(
          'Bạn có chắc chắn muốn xóa ngân sách này? Hành động không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => context.pop(true),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.bgError,
            ),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (shouldDelete ?? false) {
      await notifier.deleteBudget(context);
    }
  }
}

class _BudgetHeroCard extends StatelessWidget {
  const _BudgetHeroCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0BA360), Color(0xFF3CBA92)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budget.categoryName,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 6.h),
          Text(
            'ID: ${budget.id}',
            style: TextStyle(color: Colors.white70, fontSize: 13.sp),
          ),
          SizedBox(height: 18.h),
          Text(
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(budget.amount),
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          SizedBox(height: 8.h),
          Wrap(
            spacing: 8.w,
            children: [
              _HeroChip(
                icon: Icons.repeat,
                label: budget.period == 'monthly' ? 'Hàng tháng' : 'Hàng tuần',
              ),
              _HeroChip(
                icon: Icons.warning_amber_outlined,
                label: 'Ngưỡng ${budget.alertThreshold.toInt()}%',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: Icon(icon, color: AppColors.primaryGreen, size: 18.sp),
      label: Text(label),
      backgroundColor: Colors.white.withOpacity(0.9),
    );
  }
}

class _BudgetInfoCard extends StatelessWidget {
  const _BudgetInfoCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          _infoRow(
            context,
            'Hạn mức',
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                .format(budget.amount),
          ),
          const Divider(),
          _infoRow(
            context,
            'Kỳ hạn',
            budget.period == 'monthly' ? 'Hàng tháng' : 'Hàng tuần',
          ),
          const Divider(),
          _infoRow(
            context,
            'Ngưỡng cảnh báo',
            '${budget.alertThreshold.toInt()}%',
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
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
          style: Theme.of(context)
              .textTheme
              .bodyLarge
              ?.copyWith(color: AppColors.typoBody),
        ),
      ],
    );
  }
}

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final startDate = DateTime.fromMillisecondsSinceEpoch(budget.startDate * 1000);
    final endDate = DateTime.fromMillisecondsSinceEpoch(budget.endDate * 1000);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: AppColors.bgGray.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Khoảng thời gian', style: TextStyle(fontSize: 16.sp)),
          SizedBox(height: 12.h),
          Row(
            children: [
              Expanded(
                child: _timelineTile(
                  label: 'Bắt đầu',
                  date: DateFormat('dd/MM/yyyy').format(startDate),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: _timelineTile(
                  label: 'Kết thúc',
                  date: DateFormat('dd/MM/yyyy').format(endDate),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _timelineTile({required String label, required String date}) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(color: AppColors.typoBody, fontSize: 13.sp)),
          SizedBox(height: 4.h),
          Text(
            date,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.typoHeading,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onEdit, required this.onDelete});
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Chỉnh sửa ngân sách'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: onDelete,
            icon: const Icon(Icons.delete_outline, color: AppColors.bgError),
            label: const Text(
              'Xóa ngân sách',
              style: TextStyle(color: AppColors.bgError),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.bgError),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
          ),
        ),
      ],
    );
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Có lỗi xảy ra:\n$message',
              textAlign: TextAlign.center, style: TextStyle(fontSize: 14.sp)),
          SizedBox(height: 12.h),
          FilledButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Không tìm thấy ngân sách'));
  }
}
