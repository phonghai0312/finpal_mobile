// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/actions_button.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/budget/budget_list.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_provider.dart';
import 'package:fridge_to_fork_ai/features/stats/presentation/providers/stats_provider.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';
import 'package:go_router/go_router.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';

import '../providers/home/home_provider.dart';
import '../widgets/home_header.dart';
import '../widgets/suggestion_card.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_form_notifier.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_detail_notifier.dart';

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
      ref.read(budgetNotifierProvider.notifier).fetchBudgets();
    });
  }

  @override
  Widget build(BuildContext context) {
    // Lấy dữ liệu thực từ stats và profile
    final StatsOverview? statsOverview =
        ref.watch(statsNotifierProvider).overview;
    final profileState = ref.watch(profileNotifierProvider);
    final state = ref.watch(homeNotifierProvider);

    ref.listen<BudgetFormState>(budgetFormNotifierProvider, (previous, next) {
      if (next.isSuccess && !previous!.isSuccess) {
        ref.read(budgetNotifierProvider.notifier).fetchBudgets();
      }
    });

    // Lắng nghe detail delete (budgetDetailNotifierProvider không phải family)
    ref.listen<BudgetDetailState>(
      budgetDetailNotifierProvider,
      (previous, next) {
        if (next.budget == null &&
            previous?.budget != null &&
            !next.isLoading) {
          // A budget was deleted, refresh the list
          ref.read(budgetNotifierProvider.notifier).fetchBudgets();
        }
      },
    );

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
                  userName: profileState.user?.name ?? state.userName,
                  totalIncomeText:
                      "+${statsOverview?.totalIncome.toStringAsFixed(0) ?? '0'}đ",
                  totalExpenseText:
                      "-${statsOverview?.totalExpense.toStringAsFixed(0) ?? '0'}đ",
                  onNotificationTap: () {},
                ),

                /// 🔥 Padding chỉ áp dụng cho các phần bên dưới
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 8.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.verticalSpace,

                      /// 2 nút chức năng (thu gọn khoảng cách)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 10.h,
                        ),
                        child: ActionButtons(
                          onAddCategory: () =>
                              context.push(AppRoutes.createTransaction),
                        ),
                      ),
                      10.verticalSpace,

                      /// Biểu đồ chi tiêu (đặt trong thẻ gọn hơn)
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14.r),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 10.h,
                        ),
                        child: const BudgetList(), // Fetches real data from API
                      ),
                      12.verticalSpace,

                      /// Gợi ý thông minh
                      SuggestionCard(
                        title: state.suggestion?.title,
                        message: state.suggestion?.message,
                      ),
                      20.verticalSpace,
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
