// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../../../../core/presentation/widget/header/header_simple.dart';
import '../../../categories/presentation/provider/category.notifier.dart';
import '../../../categories/presentation/provider/category_provider.dart';
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

    // Summary theo tháng đang chọn (không phụ thuộc search/category/type chip).
    for (var t in (state.monthly ?? const <Transaction>[])) {
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
    final bgColor = isIncome ? AppColors.lightGreen : AppColors.lightRed;
    final textColor = isIncome ? AppColors.darkGreen : AppColors.darkRed;

    final amountText = NumberFormat.currency(
      locale: 'vi_VN',
      symbol: '₫',
    ).format(amount);

    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14.w),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16.r),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LABEL
            Text(
              label,
              style: TextStyle(
                fontSize: 13.sp,
                color: textColor,
                fontWeight: FontWeight.w600,
              ),
            ),

            SizedBox(height: 6.h),

            /// ICON + AMOUNT (ANTI OVERFLOW)
            Row(
              children: [
                Icon(
                  isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                  size: 16.sp,
                  color: textColor,
                ),

                SizedBox(width: 6.w),

                /// 👇 FIX QUAN TRỌNG Ở ĐÂY
                Expanded(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerLeft,
                    child: Text(
                      amountText,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: textColor,
                      ),
                    ),
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
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
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
                ],
              ),
            ),
          ),
          SizedBox(width: 12.w),
          _monthDropdown(context, state, notifier),
          SizedBox(width: 8.w),
          _iconButton(
            Icons.filter_list,
            onTap: () {
              final categoryState = ref.read(categoryNotifierProvider);
              _showCategoryFilterSheet(context, categoryState, notifier);
            },
          ),
        ],
      ),
    );
  }

  Widget _monthDropdown(
    BuildContext context,
    TransactionState state,
    TransactionNotifier notifier,
  ) {
    final options = notifier.monthOptions(count: 24);
    final selected = state.selectedMonth;

    return Container(
      height: 38.w,
      constraints: BoxConstraints(minWidth: 110.w, maxWidth: 140.w),
      padding: EdgeInsets.symmetric(horizontal: 10.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DateTime>(
          isExpanded: true,
          value: options.contains(selected) ? selected : options.first,
          icon: Icon(Icons.keyboard_arrow_down, size: 18.sp),
          selectedItemBuilder: (ctx) => options
              .map(
                (m) => Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    DateFormat('MM/yyyy').format(m),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              )
              .toList(),
          items: options
              .map(
                (m) => DropdownMenuItem<DateTime>(
                  value: m,
                  child: Text(
                    DateFormat('MM/yyyy').format(m),
                    style: TextStyle(fontSize: 12.sp),
                  ),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            notifier.setMonth(context, value);
          },
        ),
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

  Widget _iconButton(IconData icon, {VoidCallback? onTap}) {
    final button = Container(
      width: 38.w,
      height: 38.w,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400),
      ),
      child: Icon(icon, size: 18.sp),
    );

    if (onTap == null) return button;

    return GestureDetector(onTap: onTap, child: button);
  }

  void _showCategoryFilterSheet(
    BuildContext context,
    CategoryState categoryState,
    TransactionNotifier notifier,
  ) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16.r)),
      ),
      builder: (sheetContext) {
        final currentCategoryId = ref
            .read(transactionNotifierProvider)
            .currentCategoryId;
        final categories = categoryState.categories;

        return SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(2.r),
                  ),
                ),
                SizedBox(height: 12.h),
                Text(
                  'Lọc theo danh mục',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: 8.h),
                if (categoryState.isLoading)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: CircularProgressIndicator(),
                  )
                else if (categoryState.errorMessage != null)
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.h),
                    child: Text(
                      'Không thể tải danh mục: ${categoryState.errorMessage}',
                      style: TextStyle(color: Colors.red, fontSize: 13.sp),
                    ),
                  )
                else
                  ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(sheetContext).size.height * 0.6,
                    ),
                    child: ListView(
                      shrinkWrap: true,
                      children: [
                        ListTile(
                          leading: const Icon(Icons.clear_all),
                          title: const Text('Tất cả danh mục'),
                          selected: currentCategoryId == null,
                          onTap: () {
                            notifier.setCategoryFilter(null);
                            Navigator.pop(sheetContext);
                          },
                        ),
                        for (final category in categories)
                          ListTile(
                            title: Text(category.displayName),
                            selected: category.id == currentCategoryId,
                            onTap: () {
                              notifier.setCategoryFilter(category.id);
                              Navigator.pop(sheetContext);
                            },
                          ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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

    final amountText =
        "${isIncome ? '+' : '-'}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(tx.amount)}";

    return Material(
      color: Colors.transparent,
      child: InkWell(
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
              /// ICON
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

              /// TITLE + META
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tx.normalized.title ?? tx.userNote ?? "Không có tiêu đề",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 14.sp,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      "${tx.categoryName ?? 'Không xác định'} • $dateString",
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 12.sp,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(width: 8.w),

              /// 💰 AMOUNT – KHÔNG BAO GIỜ TRÀN
              ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: 110.w, // 👈 GIỚI HẠN RỘNG
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerRight,
                  child: Text(
                    amountText,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: arrowColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
