// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/actions_button.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/budget/budget_list.dart';

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
    final state = ref.watch(homeNotifierProvider);
    final budgetState = ref.watch(budgetNotifierProvider);

    ref.listen<BudgetFormState>(budgetFormNotifierProvider, (previous, next) {
      if (next.isSuccess && !previous!.isSuccess) {
        ref.read(budgetNotifierProvider.notifier).fetchBudgets();
      }
    });

    ref.listen<BudgetDetailState>(
      budgetDetailNotifierProvider(
        budgetState.budgets.isNotEmpty ? budgetState.budgets[0].id : '',
      ),
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
                      BudgetList(
                        budgets: budgetState.budgets,
                      ), // Replaced CategoryChart with BudgetList
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
