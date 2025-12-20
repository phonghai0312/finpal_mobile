// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/widget/button/button.dart';
import '../../../../core/presentation/widget/header/header_with_back.dart';
import '../../domain/entities/budget.dart';
import '../providers/budget_detail/budget_detail_provider.dart';
import '../providers/budget_detail/budget_detail_notifier.dart';

class BudgetDetailPage extends ConsumerStatefulWidget {
  const BudgetDetailPage({super.key});

  @override
  ConsumerState<BudgetDetailPage> createState() => _BudgetDetailPageState();
}

class _BudgetDetailPageState extends ConsumerState<BudgetDetailPage> {
  @override
  void initState() {
    super.initState();

    /// 🔥 Luồng mới: init notifier
    Future.microtask(() {
      ref.read(budgetDetailNotifierProvider.notifier).init();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetDetailNotifierProvider);
    final notifier = ref.read(budgetDetailNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.typoWhite,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWithBack(
              title: 'Chi tiết ngân sách',
              onBack: () => notifier.onBack(context),
            ),

            Expanded(
              child: state.isLoading && state.data == null
                  ? const Center(child: CircularProgressIndicator())
                  : state.error != null && state.data == null
                  ? _ErrorView(
                      message: state.error!,
                      onRetry: () => notifier.init(),
                    )
                  : state.data == null
                  ? const _EmptyView()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(16.w),
                      child: Column(
                        children: [
                          _HeroCard(budget: state.data!),
                          16.verticalSpace,
                          _InfoCard(budget: state.data!),
                          16.verticalSpace,
                          _TimelineCard(budget: state.data!),
                          24.verticalSpace,
                          _ActionButtons(
                            onEdit: () => notifier.onEdit(context),
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
        title: Text(
          'Xóa ngân sách',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        content: Text(
          'Bạn có chắc chắn muốn xóa ngân sách này? Hành động không thể hoàn tác.',
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => context.pop(false),
            child: Text('Hủy', style: GoogleFonts.poppins()),
          ),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: AppColors.bgError),
            onPressed: () => context.pop(true),
            child: Text('Xóa', style: GoogleFonts.poppins()),
          ),
        ],
      ),
    );

    if (ok == true) {
      await notifier.onDelete(context);
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
        color: AppColors.bgDarkGreen,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            budget.categoryName,
            style: GoogleFonts.poppins(
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
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
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
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 12.sp,
          fontWeight: FontWeight.w500,
        ),
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
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
          ),
        ),
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
          Text(
            label,
            style: GoogleFonts.poppins(
              fontSize: 12.sp,
              fontWeight: FontWeight.w400,
            ),
          ),
          4.verticalSpace,
          Text(
            DateFormat('dd/MM/yyyy').format(d),
            style: GoogleFonts.poppins(
              fontSize: 15.sp,
              fontWeight: FontWeight.w600,
            ),
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
        Button(text: 'Chỉnh sửa ngân sách', onPressed: onEdit),
        12.verticalSpace,
        Button(
          text: 'Xóa ngân sách',
          color: AppColors.bgError,
          onPressed: onDelete,
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
  style: GoogleFonts.poppins(fontSize: 16.sp, fontWeight: FontWeight.w700),
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
          Text(
            message,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(fontSize: 14.sp),
          ),
          12.verticalSpace,
          Button(text: 'Thử lại', onPressed: onRetry),
        ],
      ),
    );
  }
}

class _EmptyView extends StatelessWidget {
  const _EmptyView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Không tìm thấy ngân sách',
        style: GoogleFonts.poppins(fontSize: 14.sp),
      ),
    );
  }
}
