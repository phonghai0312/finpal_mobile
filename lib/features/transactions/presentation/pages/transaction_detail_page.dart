import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_provider.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends ConsumerWidget {
  const TransactionDetailPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(transactionDetailNotifierProvider);
    final notifier = ref.read(transactionDetailNotifierProvider.notifier);

    // gọi init sau frame đầu tiên để đảm bảo selectedTransactionId đã set
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifier.init();
    });

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${state.error}')));
    }

    final tx = state.data!;

    return Scaffold(
      appBar: HeaderWithBack(
        title: 'Chi tiết giao dịch',
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionSummaryCard(context, tx),
            SizedBox(height: 16.h),
            _buildAIClassificationBanner(context, tx),
            SizedBox(height: 16.h),
            _buildDetailItem(
              context,
              Icons.access_time,
              'Thời gian',
              _formatDate(tx.occurredAt),
            ),
            _buildDetailItem(
              context,
              Icons.category,
              'Danh mục',
              tx.categoryName ?? 'Không xác định',
            ),
            _buildDetailItem(
              context,
              Icons.credit_card,
              'Phương thức',
              tx.source ?? 'Không xác định',
            ),
            _buildDetailItem(
              context,
              Icons.location_on,
              'Địa điểm',
              tx.merchant ?? 'Không xác định',
            ),
            _buildDetailItem(
              context,
              Icons.note,
              'Ghi chú',
              tx.userNote ?? 'Không có ghi chú',
            ),
            SizedBox(height: 24.h),
            _buildActionButtons(context, ref, tx),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSummaryCard(BuildContext context, Transaction tx) {
    final isIncome = tx.type == 'income';

    return Card(
      color: isIncome ? AppColors.lightGreen : AppColors.lightRed,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
      elevation: 4, // Add elevation for a subtle shadow
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w), // Adjust padding
        child: Column(
          children: [
            CircleAvatar(
              radius: 30.r,
              backgroundColor: AppColors.bgCard,
              child: Icon(
                isIncome ? Icons.arrow_downward : Icons.arrow_upward,
                color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
                size: 30.sp,
              ),
            ),
            SizedBox(height: 16.h), // Adjust spacing
            Text(
              '${isIncome ? "+" : "-"}${NumberFormat.currency(locale: "vi_VN", symbol: "₫").format(tx.amount)}',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
                fontSize: 28.sp, // Increase font size
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.h), // Adjust spacing
            Text(
              tx.merchant ?? "Không xác định",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
                fontSize: 16.sp, // Increase font size
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAIClassificationBanner(BuildContext context, Transaction tx) {
    if (tx.ai?.categorySuggestionId == null || tx.ai?.confidence == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(16.w), // Increased padding
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.15), // Slightly darker opacity
        borderRadius: BorderRadius.circular(12.r), // More rounded corners
        border: Border.all(color: AppColors.primaryGreen, width: 1.5), // Thicker border
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 24.sp), // Changed icon and size
          SizedBox(width: 12.w), // Increased spacing
          Expanded(
            child: Text(
              'AI gợi ý danh mục "${tx.categoryName ?? "Không xác định"}" với độ chính xác ${(tx.ai!.confidence! * 100).toInt()}%',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppColors.primaryGreen,
                fontSize: 14.sp, // Increased font size
                fontWeight: FontWeight.w600, // Added bold font weight
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItem(
    BuildContext context,
    IconData icon,
    String label,
    String value,
  ) {
    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(vertical: 12.h),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 20.sp, color: AppColors.primaryGreen), // Changed icon color
              SizedBox(width: 16.w), // Increased spacing
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                          fontSize: 12.sp, color: Colors.grey[600]),
                    ),
                    SizedBox(height: 6.h), // Increased spacing
                    Text(value, style: TextStyle(fontSize: 15.sp)), // Increased font size
                  ],
                ),
              ),
            ],
          ),
        ),
        Divider(height: 1.h, color: Colors.grey[200]), // Add a divider
      ],
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Transaction tx,
  ) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () => ref
                .read(transactionDetailNotifierProvider.notifier).onEdit(context, tx),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryGreen),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h), // Increased vertical padding
            ),
            child: Text(
              'Chỉnh sửa',
              style: TextStyle(color: AppColors.primaryGreen, fontSize: 16.sp), // Increased font size
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () => ref
                .read(transactionDetailNotifierProvider.notifier).onDelete(context, tx),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkRed,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
              padding: EdgeInsets.symmetric(vertical: 16.h), // Increased vertical padding
            ),
            child: Text(
              'Xóa',
              style: TextStyle(color: AppColors.bgCard, fontSize: 16.sp), // Increased font size
            ),
          ),
        ),
      ],
    );
  }

  String _formatDate(int timestampSeconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampSeconds * 1000);
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    if (date.year == today.year &&
        date.month == today.month &&
        date.day == today.day) {
      return 'Hôm nay, ${DateFormat('HH:mm').format(date)}';
    }

    final yesterday = today.subtract(const Duration(days: 1));
    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return 'Hôm qua, ${DateFormat('HH:mm').format(date)}';
    }

    return DateFormat('dd/MM/yyyy, HH:mm').format(date);
  }
}
