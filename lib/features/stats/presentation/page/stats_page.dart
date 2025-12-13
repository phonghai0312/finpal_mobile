// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_simple.dart';

import 'package:fridge_to_fork_ai/features/stats/presentation/providers/stats_notifier.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/providers/stats_provider.dart';

import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_header.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_overview_cards.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_chart.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_category_list.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/widgets/stats_category_sheet.dart';

class StatsPage extends ConsumerStatefulWidget {
  const StatsPage({super.key});

  @override
  ConsumerState<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends ConsumerState<StatsPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(statsNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statsNotifierProvider);
    final notifier = ref.read(statsNotifierProvider.notifier);

    if (state.isLoading && state.overview == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: const HeaderSimple(title: "Thống kê"),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.only(left: 16.w, right: 16.w, bottom: 24.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 16.h),

                /// HEADER (month/year)
                StatsHeader(
                  selectedMonth: state.month,
                  selectedYear: state.year,
                  onMonthChanged: (m) =>
                      notifier.changeMonth(context, m, state.year),
                ),

                SizedBox(height: 16.h),

                /// OVERVIEW
                if (state.overview != null)
                  StatsOverviewCards(
                    income: state.overview!.totalIncome,
                    expense: state.overview!.totalExpense,
                    currency: state.overview!.currency,
                  ),

                SizedBox(height: 20.h),

                /// CHART + CATEGORY
                if (state.byCategory != null) ...[
                  StatsChart(items: state.byCategory!.items),
                  SizedBox(height: 20.h),
                  StatsCategoryList(
                    items: state.byCategory!.items,
                    onCategoryTap: (item) =>
                        _openCategoryModal(item.categoryId, item.categoryName),
                  ),
                ] else
                  SizedBox(height: 40.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // CATEGORY DETAIL BOTTOM SHEET
  // -------------------------------------------------------
  void _openCategoryModal(String categoryId, String name) {
    final state = ref.read(statsNotifierProvider);
    final notifier = ref.read(statsNotifierProvider.notifier);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => StatsCategorySheet(
        title: name,
        monthLabel: "Tháng ${state.month}/${state.year}",
        future: notifier.getTransactionsByCategory(categoryId),
      ),
    );
  }
}
