// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/widget/header/header_simple.dart';
import '../../domain/entities/transaction.dart';
import '../provider/transaction/transaction_provider.dart';
import '../provider/transaction/transaction_notifier.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  TransactionsPageState createState() => TransactionsPageState();
}

class TransactionsPageState extends ConsumerState<TransactionsPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      await ref.read(transactionNotifierProvider.notifier).init(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: const HeaderSimple(title: 'Giao dịch', onMore: null),

      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primaryGreen,
        onPressed: () => notifier.onPressAdd(context),
        child: const Icon(Icons.add, color: Colors.white),
      ),

      body: RefreshIndicator(
        color: AppColors.primaryGreen,
        onRefresh: () async => notifier.refresh(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSummaryCards(context, state),
            _buildSearchBar(context, notifier),
            _buildFilterBar(context, state, notifier),
            _buildCategoryButton(),
            Expanded(child: _buildTransactionList(context, state, notifier)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY CARDS
  // ---------------------------------------------------------------------------

  Widget _buildSummaryCards(BuildContext context, TransactionState state) {
    double income = 0;
    double expense = 0;

    for (var t in state.all) {
      if (t.type == "income") income += t.amount;
      if (t.type == "expense") expense += t.amount;
    }

    return Padding(
      padding: EdgeInsets.all(16.w),
      child: Row(
        children: [
          _summaryCard(label: "Tổng thu", amount: income, isIncome: true),
          SizedBox(width: 12.w),
          _summaryCard(label: "Tổng chi", amount: expense, isIncome: false),
        ],
      ),
    );
  }

  Widget _summaryCard({
    required String label,
    required double amount,
    required bool isIncome,
  }) {
    final color = isIncome ? AppColors.lightGreen : AppColors.lightRed;
    final arrowColor = isIncome ? AppColors.darkGreen : AppColors.darkRed;

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: arrowColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: 4.h),
            Row(
              children: [
                Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 16.sp,
                  color: arrowColor,
                ),
                SizedBox(width: 4.w),
                Text(
                  NumberFormat.currency(
                    locale: 'vi_VN',
                    symbol: '₫',
                  ).format(amount),
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: arrowColor,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH BAR
  // ---------------------------------------------------------------------------

  Widget _buildSearchBar(BuildContext context, TransactionNotifier notifier) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: TextField(
        decoration: InputDecoration(
          hintText: "Tìm kiếm giao dịch...",
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.grey[200],
          contentPadding: EdgeInsets.symmetric(vertical: 10.h),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
        ),
        onChanged: (value) => notifier.onSearchChanged(value),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER BAR (Tất cả - Thu nhập - Chi tiêu)
  // ---------------------------------------------------------------------------

  Widget _buildFilterBar(
    BuildContext context,
    TransactionState state,
    TransactionNotifier notifier,
  ) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          _chip(
            "Tất cả",
            state.currentFilter == "all",
            () => notifier.filter("all"),
          ),
          SizedBox(width: 8.w),
          _chip(
            "Thu nhập",
            state.currentFilter == "income",
            () => notifier.filter("income"),
          ),
          SizedBox(width: 8.w),
          _chip(
            "Chi tiêu",
            state.currentFilter == "expense",
            () => notifier.filter("expense"),
          ),
          const Spacer(),
          _iconButton(Icons.calendar_today),
          SizedBox(width: 8.w),
          _iconButton(Icons.filter_list),
        ],
      ),
    );
  }

  Widget _chip(String text, bool selected, VoidCallback onTap) {
    Color bg;
    Color fg;

    if (text == "Tất cả" && selected) {
      bg = AppColors.darkGreen;
      fg = Colors.white;
    } else if (text == "Thu nhập" && selected) {
      bg = AppColors.lightGreen;
      fg = AppColors.darkGreen;
    } else if (text == "Chi tiêu" && selected) {
      bg = AppColors.lightRed;
      fg = AppColors.darkRed;
    } else {
      bg = Colors.grey[300]!;
      fg = Colors.black;
    }

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: fg,
            fontSize: 13.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _iconButton(IconData icon) {
    return Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Icon(icon, size: 18.sp),
    );
  }

  // ---------------------------------------------------------------------------
  // CATEGORY BUTTON
  // ---------------------------------------------------------------------------

  Widget _buildCategoryButton() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10.w),
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.darkGreen,
            ),
            child: const Icon(Icons.folder_open, color: Colors.white),
          ),
          SizedBox(width: 12.w),
          Text(
            "Xem danh mục",
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TRANSACTION LIST
  // ---------------------------------------------------------------------------

  Widget _buildTransactionList(
    BuildContext context,
    TransactionState state,
    TransactionNotifier notifier,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.filtered.isEmpty) {
      return Center(
        child: Text("Không có giao dịch", style: TextStyle(fontSize: 14.sp)),
      );
    }

    return ListView.builder(
      physics: const BouncingScrollPhysics(),
      itemCount: state.filtered.length,
      padding: EdgeInsets.all(16.w),
      itemBuilder: (context, index) {
        final tx = state.filtered[index];
        return Padding(
          padding: EdgeInsets.only(bottom: 12.h),
          child: _transactionItem(context, tx, notifier),
        );
      },
    );
  }

  Widget _transactionItem(
    BuildContext context,
    Transaction tx,
    TransactionNotifier notifier,
  ) {
    final isIncome = tx.type == "income";
    final arrowColor = isIncome ? AppColors.darkGreen : AppColors.darkRed;
    final bgColor = isIncome ? AppColors.lightGreen : AppColors.lightRed;

    final dateString = DateFormat(
      "dd/MM/yyyy, HH:mm",
    ).format(DateTime.fromMillisecondsSinceEpoch(tx.occurredAt));

    return InkWell(
      borderRadius: BorderRadius.circular(14.r),
      onTap: () => notifier.onTransactionSelected(context, tx),
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.r,
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
              "${isIncome ? '+' : '-'}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(tx.amount)}",
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
}
