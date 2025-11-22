import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/providers/month_filter_provider.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_chart_colors.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category_item.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/providers/stats_notifier.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/providers/stats_provider.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_category_list.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_chart.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_header.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_overview_cards.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:intl/intl.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() => ref.read(statsNotifierProvider.notifier).init());
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statsNotifierProvider);
    final monthFilter = ref.watch(monthFilterProvider);
    _handleError(state);

    final overview = state.overview;
    final byCategory = state.byCategory;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: state.isLoading && !state.hasData
            ? const Center(child: CircularProgressIndicator())
            : RefreshIndicator(
                onRefresh: () =>
                    ref.read(statsNotifierProvider.notifier).refresh(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 20.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      StatsHeader(
                        selectedMonth: monthFilter.month,
                        selectedYear: monthFilter.year,
                        onMonthChanged: (month) => ref
                            .read(monthFilterProvider.notifier)
                            .setMonth(month),
                      ),
                      if (overview != null) ...[
                        SizedBox(height: 16.h),
                        StatsOverviewCards(
                          income: overview.totalIncome,
                          expense: overview.totalExpense,
                          currency: overview.currency,
                        ),
                      ],
                      if (byCategory != null) ...[
                        SizedBox(height: 12.h),
                        StatsChart(items: byCategory.items),
                        SizedBox(height: 20.h),
                        StatsCategoryList(
                          items: byCategory.items,
                          onCategoryTap: (item) =>
                              _onCategoryTap(item, monthFilter),
                        ),
                      ] else ...[
                        SizedBox(height: 24.h),
                        _buildEmptyState(),
                      ],
                      SizedBox(height: 40.h),
                    ],
                  ),
                ),
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          Icon(Icons.insert_chart, size: 48.sp, color: Colors.grey[400]),
          SizedBox(height: 12.h),
          Text(
            'Chưa có dữ liệu thống kê',
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

  void _handleError(StatsState state) {
    final error = state.errorMessage;
    if (error == null || !mounted) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      ref.read(statsNotifierProvider.notifier).clearError();
    });
  }

  void _onCategoryTap(StatsByCategoryItem item, MonthFilterState filter) {
    final notifier = ref.read(statsNotifierProvider.notifier);
    // Determine the color based on the item's index in the overall list if possible,
    // or use a default/placeholder color.
    // For this example, let's assume we can get the index from the byCategory.items list
    final byCategoryItems =
        ref.read(statsNotifierProvider).byCategory?.items ?? [];
    final itemIndex = byCategoryItems.indexOf(item);
    final itemColor =
        AppChartColors.colors[itemIndex % AppChartColors.colors.length];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return _CategoryTransactionsSheet(
          title: item.categoryName,
          periodLabel: 'Tháng ${filter.month}/${filter.year}',
          future: notifier.getTransactionsByCategory(item.categoryId),
          categoryColor: itemColor,
        );
      },
    );
  }
}

class _CategoryTransactionsSheet extends StatelessWidget {
  final String title;
  final String periodLabel;
  final Future<List<Transaction>> future;
  final Color categoryColor;

  const _CategoryTransactionsSheet({
    required this.title,
    required this.periodLabel,
    required this.future,
    required this.categoryColor,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');

    return Container(
      height: screenHeight * 0.7,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: 16.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            child: Container(
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2.r),
              ),
            ),
          ),
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    periodLabel,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),
          SizedBox(height: 8.h),
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: future,
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const Center(child: CircularProgressIndicator());
                }
                final transactions = snapshot.data ?? [];
                if (transactions.isEmpty) {
                  return Center(
                    child: Text(
                      'Không có giao dịch nào trong danh mục này',
                      style: TextStyle(
                        fontSize: 14.sp,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                  );
                }

                return ListView.separated(
                  padding: EdgeInsets.only(top: 8.h),
                  itemCount: transactions.length,
                  separatorBuilder: (_, __) => Divider(height: 20.h),
                  itemBuilder: (context, index) {
                    final tx = transactions[index];
                    final isIncome = tx.type == 'income';
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 40.w,
                          height: 40.w,
                          decoration: BoxDecoration(
                            color: categoryColor.withOpacity(
                              0.1,
                            ), // Use categoryColor
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: categoryColor, // Use categoryColor
                            size: 20.sp,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.normalized.title ??
                                    tx.merchant ??
                                    'Giao dịch',
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDate(tx.occurredAt),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Text(
                          '${isIncome ? '+' : '-'}${formatter.format(tx.amount)}',
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: categoryColor, // Use categoryColor
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(int timestampSeconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000);
    return DateFormat('dd/MM/yyyy • HH:mm').format(date);
  }
}
