// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/providers/home/home_provider.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/home_header.dart';
import 'package:fridge_to_fork_ai/features/home/presentation/widgets/budget/budget_list.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      Future.microtask(
        () => ref.read(homeNotifierProvider.notifier).init(context),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(homeNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: RefreshIndicator(
          color: AppColors.primaryGreen,
          onRefresh: () =>
              ref.read(homeNotifierProvider.notifier).onRefresh(context),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// ================= HEADER =================
                HomeHeader(
                  userName: state.user?.name ?? '',
                  totalIncomeText: "+${_formatMoney(state.totalIncome)}",
                  totalExpenseText: "-${_formatMoney(state.totalExpense)}",
                  onNotificationTap: () {},
                ),

                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16.w),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.verticalSpace,

                      /// ================= NGÂN SÁCH =================
                      Text(
                        "Ngân sách",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      12.verticalSpace,

                      const BudgetList(),

                      16.verticalSpace,

                      /// ================= HẠN MỨC =================
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.bgDarkGreen,
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          onPressed: () => ref
                              .read(homeNotifierProvider.notifier)
                              .onButtonSeeAllBudgets(context),
                          child: Text(
                            "Hạn mức chi tiêu",
                            style: TextStyle(
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w600,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),

                      24.verticalSpace,

                      /// ================= CHI TIÊU GẦN ĐÂY =================
                      Text(
                        "Chi tiêu gần đây",
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      12.verticalSpace,

                      if (state.recentTransactions.isEmpty)
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 24.h),
                          child: Center(
                            child: Text(
                              "Chưa có giao dịch nào",
                              style: TextStyle(
                                fontSize: 13.sp,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        )
                      else
                        ListView.separated(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: state.recentTransactions.length,
                          separatorBuilder: (_, __) => SizedBox(height: 12.h),
                          itemBuilder: (context, index) {
                            final tx = state.recentTransactions[index];
                            return _recentTransactionItem(context, tx);
                          },
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

  // ======================================================
  // TRANSACTION ITEM – STYLE GIỐNG TransactionsPage
  // ======================================================

  Widget _recentTransactionItem(BuildContext context, Transaction tx) {
    final isIncome = tx.type == "income";
    final arrowColor = isIncome ? AppColors.darkGreen : AppColors.darkRed;
    final bgColor = isIncome ? AppColors.lightGreen : AppColors.lightRed;

    final dateString = DateFormat(
      "dd/MM/yyyy, HH:mm",
    ).format(DateTime.fromMillisecondsSinceEpoch(tx.occurredAt));

    return InkWell(
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.r,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 20.r,
              backgroundColor: bgColor,
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: arrowColor,
                size: 20.sp,
              ),
            ),

            SizedBox(width: 12.w),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tx.normalized.title ?? tx.userNote ?? "Không có tiêu đề",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "${tx.categoryName ?? 'Không xác định'} • $dateString",
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: 8.w),

            Text(
              "${isIncome ? '+' : '-'}${_formatMoney(tx.amount)}",
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: arrowColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatMoney(num value) {
    return NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(value);
  }
}
