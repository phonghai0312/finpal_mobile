// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/widget/header/header_with_back.dart';
import '../../domain/entities/budget.dart';
import '../providers/budget_provider.dart';
import '../providers/budget_detail_notifier.dart';

class BudgetDetailPage extends ConsumerStatefulWidget {
  final String budgetId;
  const BudgetDetailPage({super.key, required this.budgetId});

  @override
  ConsumerState<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends ConsumerState<BudgetDetailPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(selectedBudgetIdProvider.notifier).state = widget.budgetId;
    });
  }

  @override
  void dispose() {
    ref.read(selectedBudgetIdProvider.notifier).state = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetDetailNotifierProvider);
    final notifier = ref.read(budgetDetailNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            HeaderWithBack(
              title: 'Chi tiết ngân sách',
              onBack: () => context.go(AppRoutes.home),
            ),

            Expanded(
              child: state.isLoading && state.budget == null
                  ? const Center(child: CircularProgressIndicator())
                  : state.errorMessage != null && state.budget == null
                  ? _ErrorView(
                      message: state.errorMessage!,
                      onRetry: () {
                        ref.read(selectedBudgetIdProvider.notifier).state =
                            widget.budgetId;
                      },
                    )
                  : state.budget == null
                  ? const _EmptyView()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _HeroCard(budget: state.budget!),
                          16.verticalSpace,
                          _InfoCard(budget: state.budget!),
                          16.verticalSpace,
                          _TimelineCard(budget: state.budget!),
                          24.verticalSpace,
                          _ActionButtons(
                            onEdit: () => notifier.goToEdit(context),
                            onDelete: () => _confirmDelete(context, notifier),
                          ),
                        ],
                      ),
                    ),
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
    final ok = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
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
            style: FilledButton.styleFrom(backgroundColor: AppColors.bgError),
            onPressed: () => context.pop(true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );

    if (ok == true) {
      await notifier.deleteBudget(context);
    }
  }
}

/* -------------------------------------------------------------------------- */
/*                                   HERO                                     */
/* -------------------------------------------------------------------------- */

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budget.categoryName,
            style: TextStyle(
              color: Colors.white,
              fontSize: 20.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          12.verticalSpace,
          Text(
            NumberFormat.currency(
              locale: 'vi_VN',
              symbol: '₫',
            ).format(budget.amount),
            style: TextStyle(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          12.verticalSpace,
          Wrap(
            spacing: 8.w,
            children: [
              _Chip(
                label: budget.period == 'monthly' ? 'Hàng tháng' : 'Hàng tuần',
              ),
              _Chip(label: 'Ngưỡng ${budget.alertThreshold.toInt()}%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Text(
        label,
        style: TextStyle(color: Colors.white, fontSize: 12.sp),
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                   INFO                                     */
/* -------------------------------------------------------------------------- */

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    return _Card(
      children: [
        _row('Hạn mức', _money(budget.amount)),
        const Divider(),
        _row('Kỳ hạn', budget.period == 'monthly' ? 'Hàng tháng' : 'Hàng tuần'),
        const Divider(),
        _row('Ngưỡng cảnh báo', '${budget.alertThreshold.toInt()}%'),
      ],
    );
  }

  Widget _row(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600),
        ),
        Text(value, style: TextStyle(fontSize: 14.sp)),
      ],
    );
  }

  String _money(double v) =>
      NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(v);
}

/* -------------------------------------------------------------------------- */
/*                                  TIMELINE                                  */
/* -------------------------------------------------------------------------- */

class _TimelineCard extends StatelessWidget {
  const _TimelineCard({required this.budget});
  final Budget budget;

  @override
  Widget build(BuildContext context) {
    final start = DateTime.fromMillisecondsSinceEpoch(budget.startDate * 1000);
    final end = DateTime.fromMillisecondsSinceEpoch(budget.endDate * 1000);

    return _Card(
      children: [
        _sectionTitle('Khoảng thời gian'),
        12.verticalSpace,
        Row(
          children: [
            Expanded(child: _dateBox('Bắt đầu', start)),
            12.horizontalSpace,
            Expanded(child: _dateBox('Kết thúc', end)),
          ],
        ),
      ],
    );
  }

  Widget _dateBox(String label, DateTime d) {
    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.bgSecondary,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: TextStyle(fontSize: 12.sp)),
          4.verticalSpace,
          Text(
            DateFormat('dd/MM/yyyy').format(d),
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                 ACTIONS                                    */
/* -------------------------------------------------------------------------- */

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.onEdit, required this.onDelete});
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FilledButton(
          onPressed: onEdit,
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.primaryGreen,
            minimumSize: Size.fromHeight(48.h),
          ),
          child: const Text('Chỉnh sửa ngân sách'),
        ),
        12.verticalSpace,
        OutlinedButton(
          onPressed: onDelete,
          style: OutlinedButton.styleFrom(
            minimumSize: Size.fromHeight(48.h),
            side: const BorderSide(color: AppColors.bgError),
          ),
          child: const Text(
            'Xóa ngân sách',
            style: TextStyle(color: AppColors.bgError),
          ),
        ),
      ],
    );
  }
}

/* -------------------------------------------------------------------------- */
/*                                  SHARED                                    */
/* -------------------------------------------------------------------------- */

Widget _sectionTitle(String text) => Text(
  text,
  style: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w700),
);

class _Card extends StatelessWidget {
  const _Card({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
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
          Text(message, textAlign: TextAlign.center),
          12.verticalSpace,
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
