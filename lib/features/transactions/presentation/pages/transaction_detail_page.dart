import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../core/presentation/theme/app_colors.dart';
import '../provider/transaction_detail_provider.dart';
import '../../../features/categories/presentation/provider/category_provider.dart';

class TransactionDetailPage extends ConsumerWidget {
  final String transactionId;

  const TransactionDetailPage({super.key, required this.transactionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactionAsync = ref.watch(transactionDetailNotifierProvider(transactionId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết giao dịch'),
        centerTitle: true,
      ),
      body: transactionAsync.when(
        data: (transaction) {
          return SingleChildScrollView(
            padding: EdgeInsets.all(16.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTransactionSummaryCard(context, transaction),
                SizedBox(height: 16.h),
                _buildAIClassificationBanner(context, transaction),
                SizedBox(height: 16.h),
                _buildDetailItem(context, Icons.access_time, 'Thời gian', _formatDate(transaction.occurredAt)),
                _buildDetailItem(context, Icons.category, 'Danh mục', transaction.categoryName ?? 'Không xác định'),
                _buildDetailItem(context, Icons.credit_card, 'Phương thức', transaction.source ?? 'Không xác định'),
                _buildDetailItem(context, Icons.location_on, 'Địa điểm', transaction.merchant ?? 'Không xác định'),
                _buildDetailItem(context, Icons.note, 'Ghi chú', transaction.userNote ?? 'Không có ghi chú'),
                SizedBox(height: 24.h),
                _buildActionButtons(context, ref, transaction),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(child: Text('Error: $error')),
      ),
    );
  }

  Widget _buildTransactionSummaryCard(BuildContext context, TransactionEntity transaction) {
    return Card(
      color: transaction.type == 'income' ? AppColors.lightGreen : AppColors.lightRed,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.white,
              child: Icon(
                transaction.type == 'income' ? Icons.arrow_downward : Icons.arrow_upward,
                color: transaction.type == 'income' ? AppColors.darkGreen : AppColors.darkRed,
                size: 30.sp,
              ),
            ),
            SizedBox(height: 12.h),
            Text(
              '${transaction.type == 'income' ? '+' : '-'}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(transaction.amount)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: transaction.type == 'income' ? AppColors.darkGreen : AppColors.darkRed,
                fontSize: 24.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 4.h),
            Text(
              transaction.merchant ?? 'Không xác định',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: transaction.type == 'income' ? AppColors.darkGreen : AppColors.darkRed,
                fontSize: 14.sp,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIClassificationBanner(BuildContext context, TransactionEntity transaction) {
    if (transaction.ai?.categorySuggestionId != null && transaction.ai?.confidence != null) {
      return Container(
        padding: EdgeInsets.all(12.w),
        decoration: BoxDecoration(
          color: AppColors.yellowLight,
          borderRadius: BorderRadius.circular(8.r),
        ),
        child: Row(
          children: [
            Icon(Icons.star, color: AppColors.yellowDark, size: 20.sp),
            SizedBox(width: 8.w),
            Expanded(
              child: Text(
                'Giao dịch này được AI phân loại vào danh mục "${transaction.categoryName ?? 'Không xác định'}" với độ chính xác ${(transaction.ai!.confidence! * 100).toInt()}%',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.yellowDark,
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildDetailItem(BuildContext context, IconData icon, String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20.sp, color: Colors.grey[600]),
          SizedBox(width: 12.w),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontSize: 12.sp,
                  color: Colors.grey[600],
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                value,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontSize: 14.sp),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, TransactionEntity transaction) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              _showEditTransactionDialog(context, ref, transaction);
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryGreen),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(
              'Chỉnh sửa',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.primaryGreen, fontSize: 14.sp),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              // TODO: Implement delete functionality
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkRed,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            child: Text(
              'Xóa',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.white, fontSize: 14.sp),
            ),
          ),
        ),
      ],
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

  Future<void> _showEditTransactionDialog(BuildContext context, WidgetRef ref, TransactionEntity transaction) async {
    final TextEditingController noteController = TextEditingController(text: transaction.userNote);
    String? selectedCategoryId = transaction.categoryId;

    final categoriesAsyncValue = ref.watch(categoriesProvider);

    return showDialog<void>(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Chỉnh sửa giao dịch'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                categoriesAsyncValue.when(
                  data: (categories) {
                    return DropdownButtonFormField<String>(
                      value: selectedCategoryId,
                      decoration: const InputDecoration(
                        labelText: 'Danh mục',
                        border: OutlineInputBorder(),
                      ),
                      items: categories.map((category) {
                        return DropdownMenuItem<String>(
                          value: category.id,
                          child: Text(category.displayName),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        selectedCategoryId = newValue;
                      },
                    );
                  },
                  loading: () => const CircularProgressIndicator(),
                  error: (error, stack) => Text('Error loading categories: $error'),
                ),
                SizedBox(height: 16.h),
                TextField(
                  controller: noteController,
                  decoration: const InputDecoration(
                    labelText: 'Ghi chú',
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Hủy'),
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
            ),
            ElevatedButton(
              child: const Text('Lưu'),
              onPressed: () async {
                await ref.read(transactionDetailNotifierProvider(transaction.id).notifier).updateTransaction(
                      id: transaction.id,
                      categoryId: selectedCategoryId,
                      userNote: noteController.text.isEmpty ? null : noteController.text,
                    );
                if (dialogContext.mounted) {
                  Navigator.of(dialogContext).pop();
                }
              },
            ),
          ],
        );
      },
    );
  }
}
