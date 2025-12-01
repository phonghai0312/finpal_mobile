// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    Future.microtask(() {
      ref.read(statsNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(statsNotifierProvider);
    final notifier = ref.read(statsNotifierProvider.notifier);

    _listenError(state, notifier);

    return Scaffold(
      appBar: HeaderSimple(title: "Thống kê"),
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () => notifier.refresh(context),
          child: _buildBody(state, notifier),
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // BODY
  // -------------------------------------------------------
  Widget _buildBody(StatsState state, StatsNotifier notifier) {
    if (state.isLoading && state.overview == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          StatsHeader(
            selectedMonth: state.month,
            selectedYear: state.year,
            onMonthChanged: (m) => notifier.changeMonth(context, m, state.year),
          ),

          const SizedBox(height: 16),

          if (state.overview != null)
            StatsOverviewCards(
              income: state.overview!.totalIncome,
              expense: state.overview!.totalExpense,
              currency: state.overview!.currency,
            ),

          const SizedBox(height: 20),

          if (state.byCategory != null) ...[
            StatsChart(items: state.byCategory!.items),
            const SizedBox(height: 20),
            StatsCategoryList(
              items: state.byCategory!.items,
              onCategoryTap: (item) =>
                  _openCategoryModal(item.categoryId, item.categoryName, state),
            ),
          ] else
            _buildEmptyState(),

          const SizedBox(height: 40),
        ],
      ),
    );
  }

  // -------------------------------------------------------
  // OPEN BOTTOM SHEET
  // -------------------------------------------------------
  void _openCategoryModal(String categoryId, String name, StatsState state) {
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

  // -------------------------------------------------------
  // EMPTY STATE
  // -------------------------------------------------------
  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.only(top: 40),
      child: Center(
        child: Column(
          children: const [
            Icon(Icons.insert_chart, size: 48, color: Colors.grey),
            SizedBox(height: 12),
            Text("Chưa có dữ liệu thống kê"),
          ],
        ),
      ),
    );
  }

  // -------------------------------------------------------
  // HANDLE ERROR FROM NOTIFIER
  // -------------------------------------------------------
  void _listenError(StatsState state, StatsNotifier notifier) {
    final error = state.errorMessage;
    if (error == null) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Colors.red),
      );
      notifier.clearError();
    });
  }
}
