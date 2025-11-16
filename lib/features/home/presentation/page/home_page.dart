// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/actions_button.dart';

import '../providers/home/home_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/category_chart.dart';
import '../widgets/suggestion_card.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(homeNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          onRefresh: () =>
              ref.read(homeNotifierProvider.notifier).onRefresh(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// 🔥 HEADER FULL WIDTH — KHÔNG padding
                HomeHeader(
                  userName: state.userName,
                  totalIncomeText: "+${state.overview?.totalIncome ?? 0}đ",
                  totalExpenseText: "-${state.overview?.totalExpense ?? 0}đ",
                  onNotificationTap: () {},
                ),

                /// 🔥 Padding chỉ áp dụng cho các phần bên dưới
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      12.verticalSpace,

                      /// 2 nút chức năng
                      const ActionButtons(),
                      16.verticalSpace,

                      /// Biểu đồ chi tiêu
                      CategoryChart(statsByCategory: state.statsByCategory),
                      16.verticalSpace,

                      /// Gợi ý thông minh
                      SuggestionCard(
                        title: state.suggestion?.title,
                        message: state.suggestion?.message,
                      ),
                      24.verticalSpace,
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
