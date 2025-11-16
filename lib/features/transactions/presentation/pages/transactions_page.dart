import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../provider/transaction_provider.dart';
import '../provider/transaction_state.dart';

class TransactionsPage extends ConsumerWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionState = ref.watch(transactionNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giao dịch'),
        centerTitle: true,
      ),
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
                      child: _buildTransactionList(context, transactionState),
                    ),
                  ],
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO: Implement add new transaction
        },
        backgroundColor: AppColors.primaryGreen,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildSummaryCards(BuildContext context, TransactionState state) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: Card(
              color: AppColors.lightGreen,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng thu',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: AppColors.darkGreen),
                    ),
                    Text(
                      '+${NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                          .format(state.totalIncome)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.darkGreen),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Card(
              color: AppColors.lightRed,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tổng chi',
                      style: Theme.of(context).textTheme.titleMedium
                          ?.copyWith(color: AppColors.darkRed),
                    ),
                    Text(
                      '-${NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                          .format(state.totalExpense)}',
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(color: AppColors.darkRed),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          hintText: 'Tìm kiếm giao dịch...',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
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
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          FilterChip(
            label: const Text('Tất cả'),
            selected: true, // Assuming default to "Tất cả"
            onSelected: (selected) {
              // TODO: Implement filter for all transactions
            },
            selectedColor: AppColors.primaryGreen,
            labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
            ),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 8),
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
            ),
            backgroundColor: Colors.grey[300],
          ),
          const SizedBox(width: 8),
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
            ),
            backgroundColor: Colors.grey[300],
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Implement calendar filter
            },
            icon: const Icon(Icons.calendar_today),
          ),
          IconButton(
            onPressed: () {
              // TODO: Implement more filters
            },
            icon: const Icon(Icons.filter_list),
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.folder_open),
          const SizedBox(width: 8),
          Text(
            'Xem danh mục',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButton(
            onPressed: () {
              // TODO: Implement category view
            },
            icon: const Icon(Icons.arrow_forward_ios),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionList(BuildContext context, TransactionState state) {
    return ListView.builder(
      itemCount: state.transactions.length,
      itemBuilder: (context, index) {
        final transaction = state.transactions[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: transaction.type == 'income'
                  ? AppColors.lightGreen
                  : AppColors.lightRed,
              child: Icon(
                transaction.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                color: transaction.type == 'income'
                    ? AppColors.darkGreen
                    : AppColors.darkRed,
              ),
            ),
            title: Text(
              transaction.normalized.title ?? 'Không có tiêu đề',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            subtitle: Text(
              '${transaction.categoryName ?? 'Không xác định'} • ${_formatDate(transaction.occurredAt)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            trailing: Text(
              '${transaction.type == 'income' ? '+' : '-'}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                  .format(transaction.amount)}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: transaction.type == 'income'
                    ? AppColors.darkGreen
                    : AppColors.darkRed,
              ),
            ),
            onTap: () {
              // TODO: Implement navigation to transaction detail page
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

  Widget _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      selectedItemColor: AppColors.primaryGreen,
      unselectedItemColor: Colors.grey,
      currentIndex: 1, // 'Giao dịch' tab
      onTap: (index) {
        // TODO: Implement navigation for bottom navigation bar
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.currency_exchange),
          label: 'Giao dịch',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Thống kê',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.lightbulb_outline),
          label: 'Gợi ý',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Cá nhân',
        ),
      ],
    );
  }
}
