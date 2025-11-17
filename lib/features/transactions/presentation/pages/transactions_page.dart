import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_notifier.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../provider/transaction_notifier.dart';
import '../provider/transaction_provider.dart';
import 'package:go_router/go_router.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});


  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionNotifierProvider);
    final notifier = ref.read(transactionNotifierProvider.notifier);
    return Scaffold(
      appBar: AppBar(title: const Text('Giao dịch'), centerTitle: true),
      body: transactionState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : transactionState.errorMessage != null
          ? Center(child: Text('Error: ${transactionState.errorMessage}'))
          : Column(
              children: [
                _buildSummaryCards(context, transactionState),
                _buildSearchBar(context),
                _buildFilterButtons(context, ref),
                _buildCategorySection(context),
                Expanded(
                  child: _buildTransactionList(context, transactionState, ref),
                ),
              ],
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => notifier.onPress(context),
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildSummaryCards(BuildContext context, TransactionState state) {
    return Padding(
      padding: EdgeInsets.all(16.w), // dùng screenutil
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: AppColors.lightGreen,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng thu',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkGreen,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      '+${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(state.totalIncome)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            color: AppColors.darkGreen,
                            fontSize: 18.sp,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Card(
              color: AppColors.lightRed,
              child: Padding(
                padding: EdgeInsets.all(16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng chi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.darkRed,
                        fontSize: 14.sp,
                      ),
                    ),
                    Text(
                      '-${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(state.totalExpense)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.darkRed, fontSize: 18.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm giao dịch...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.r),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey[200],
        ),
      ),
    );
  }

  Widget _buildFilterButtons(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Tất cả'),
            selected: true,
            onSelected: (selected) {},
            selectedColor: AppColors.primaryGreen,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 12.sp,
            ),
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(width: 8.w),
          FilterChip(
            label: const Text('Thu nhập'),
            selected: false,
            onSelected: (selected) {
              ref
                  .read(transactionNotifierProvider.notifier)
                  .fetchTransactions(type: 'income');
            },
            selectedColor: AppColors.primaryGreen,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 12.sp,
            ),
            backgroundColor: Colors.grey[300],
          ),
          SizedBox(width: 8.w),
          FilterChip(
            label: const Text('Chi tiêu'),
            selected: false,
            onSelected: (selected) {
              ref
                  .read(transactionNotifierProvider.notifier)
                  .fetchTransactions(type: 'expense');
            },
            selectedColor: AppColors.primaryGreen,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontSize: 12.sp,
            ),
            backgroundColor: Colors.grey[300],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.calendar_today, size: 20.sp),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.filter_list, size: 20.sp),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      child: Row(
        children: [
          Icon(Icons.folder_open, size: 20.sp),
          SizedBox(width: 8.w),
          Text(
            'Xem danh mục',
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontSize: 14.sp),
          ),
          const Spacer(),
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.arrow_forward_ios, size: 20.sp),
          ),
        ],
      ),
    );
  }

  //👉 BuildContext thuộc về Flutter, không liên quan đến Riverpod.
  //
  // Nó dùng để:
  //
  // truy cập cây widget (widget tree)
  //
  // lấy theme, mediaQuery, navigator
  //
  // mở dialog, push trang, pop trang
  //
  // lấy các widget ancestor (ví dụ ScaffoldMessenger, Theme, InheritedWidget)
  //
  // Nói ngắn gọn:
  //
  // BuildContext = "vị trí của widget trong cây UI".
  //
  // Ví dụ dùng context:
  //
  // Navigator.push(context, ...);
  // Theme.of(context);
  // MediaQuery.of(context);
  // ScaffoldMessenger.of(context).showSnackBar(...)
  //
  // 🎯 2. WidgetRef là gì?
  //
  // 👉 WidgetRef thuộc về Riverpod, hoàn toàn không liên quan đến Flutter UI.
  //
  // Nó dùng để:
  //
  // đọc provider → ref.read()
  //
  // lắng nghe provider → ref.watch()
  //
  // subscribe, dispose provider
  //
  // tạo listener khi state thay đổi
  //
  // Nói ngắn gọn:
  //
  // WidgetRef = cách để yêu cầu, đọc, theo dõi provider của Riverpod.
  //
  Widget _buildTransactionList(
    BuildContext context,
    TransactionState state,
    WidgetRef ref,
  ) {
    return ListView.builder(
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final transaction = state.transactions[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 4.h),
          child: ListTile(
            leading: CircleAvatar(
              radius: 20.r,
              backgroundColor: transaction.type == 'income'
                  ? AppColors.lightGreen
                  : AppColors.lightRed,
              child: Icon(
                transaction.type == 'income'
                    ? Icons.arrow_downward
                    : Icons.arrow_upward,
                color: transaction.type == 'income'
                    ? AppColors.darkGreen
                    : AppColors.darkRed,
                size: 20.sp,
              ),
            ),
            title: Text(
              transaction.normalized.title ?? 'Không có tiêu đề',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 14.sp),
            ),
            subtitle: Text(
              '${transaction.categoryName ?? 'Không xác định'} • ${_formatDate(transaction.occurredAt)}',
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(fontSize: 12.sp),
            ),
            trailing: Text(
              '${transaction.type == 'income' ? '+' : '-'}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(transaction.amount)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: transaction.type == 'income'
                    ? AppColors.darkGreen
                    : AppColors.darkRed,
                fontSize: 14.sp,
              ),
            ),
            onTap: () {
              ref.read(selectedTransactionIdProvider.notifier).state = transaction.id;
              context.go('${AppRoutes.transactionDetail}');
            },
          ),
        );
      },
    );
  }

  String _formatDate(int timestamp) {
    final dateTime = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final yesterday = DateTime(now.year, now.month, now.day - 1);

    if (dateTime.year == today.year &&
        dateTime.month == today.month &&
        dateTime.day == today.day) {
      return 'Hôm nay, ${DateFormat('HH:mm').format(dateTime)}';
    } else if (dateTime.year == yesterday.year &&
        dateTime.month == yesterday.month &&
        dateTime.day == yesterday.day) {
      return 'Hôm qua, ${DateFormat('HH:mm').format(dateTime)}';
    } else {
      return '${DateFormat('dd/MM/yyyy, HH:mm').format(dateTime)}';
    }
  }
}
