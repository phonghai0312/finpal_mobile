import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transactiondetail/transaction_detail_notifier.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transactiondetail/transaction_detail_provider.dart';
import 'package:intl/intl.dart';

class TransactionDetailPage extends ConsumerStatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  ConsumerState<TransactionDetailPage> createState() =>
      _TransactionDetailPageState();
}

class _TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  late TextEditingController noteCtrl;
  late TextEditingController merchantCtrl;
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      final notifier = ref.read(transactionDetailNotifierProvider.notifier);
      await notifier.init();

      final tx = ref.read(transactionDetailNotifierProvider).data;
      if (tx != null) {
        noteCtrl = TextEditingController(text: tx.userNote);
        merchantCtrl = TextEditingController(text: tx.merchant);
      }
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionDetailNotifierProvider);
    final notifier = ref.read(transactionDetailNotifierProvider.notifier);
    final isEditing = state.isEditing;

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(body: Center(child: Text(state.error!)));
    }

    final tx = state.data!;

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      appBar: HeaderWithBack(
        title: isEditing ? 'Chỉnh sửa giao dịch' : 'Chi tiết giao dịch',
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTransactionSummaryCard(context, tx),
            SizedBox(height: 12.h),

            /// AI Suggestion
            _buildAIClassificationBanner(context, tx),
            SizedBox(height: 12.h),

            /// TIME (Không cho sửa)
            _buildEditableCard(
              isEditing: isEditing,
              label: 'Thời gian',
              value: _formatDate(tx.occurredAt),
            ),

            /// CATEGORY (Không cho sửa)
            _buildEditableCard(
              isEditing: isEditing,
              label: 'Danh mục',
              value: tx.categoryName ?? 'Không xác định',
            ),

            /// SOURCE (Không cho sửa)
            _buildEditableCard(
              isEditing: isEditing,
              label: 'Phương thức',
              value: tx.source,
            ),

            /// MERCHANT — CHO PHÉP SỬA
            _buildEditableCard(
              isEditing: isEditing,
              label: 'Địa điểm',
              value: tx.merchant ?? 'Không xác định',
              controller: merchantCtrl,
            ),

            /// USER NOTE — CHO PHÉP SỬA
            _buildEditableCard(
              isEditing: isEditing,
              label: 'Ghi chú',
              value: tx.userNote ?? 'Không có ghi chú',
              controller: noteCtrl,
            ),

            SizedBox(height: 24.h),

            /// BUTTONS
            _buildActionButtons(context, ref, tx, notifier, isEditing),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionSummaryCard(BuildContext context, Transaction tx) {
    final isIncome = tx.type == 'income';

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isIncome ? AppColors.lightGreen : AppColors.lightRed,
        borderRadius: BorderRadius.circular(20.r),
      ),
      padding: EdgeInsets.symmetric(vertical: 24.h, horizontal: 20.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundColor: AppColors.bgCard,
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            '${isIncome ? "+" : "-"}${NumberFormat.currency(locale: "vi_VN", symbol: "₫").format(tx.amount)}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
              fontSize: 24.sp,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            tx.merchant ?? "Không xác định",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.black87,
              fontSize: 14.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAIClassificationBanner(BuildContext context, Transaction tx) {
    if (tx.ai.categorySuggestionId == null || tx.ai.confidence == null) {
      return const SizedBox.shrink();
    }

    final confidencePercent = (tx.ai.confidence! * 100).toInt();
    final categoryName = tx.categoryName ?? 'Không xác định';

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: Colors.orange[600], size: 22.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontSize: 13.sp,
                  color: Colors.orange[900],
                ),
                children: [
                  TextSpan(
                    text: 'Phân loại tự động bởi AI\n',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 13.sp,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Giao dịch này được AI phân loại vào danh mục "$categoryName" với độ chính xác $confidencePercent%.',
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableCard({
    required String label,
    required String value,
    TextEditingController? controller,
    required bool isEditing,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: Colors.grey.shade300, width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey[600]),
          ),
          SizedBox(height: 6.h),

          isEditing && controller != null
              ? TextField(
                  controller: controller,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                  ),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                )
              : Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    WidgetRef ref,
    Transaction tx,
    TransactionDetailNotifier notifier,
    bool isEditing,
  ) {
    if (!isEditing) {
      return Row(
        children: [
          // Nút Chỉnh sửa
          Expanded(
            child: SizedBox(
              height: 50.h,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.primaryGreen, width: 1.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: notifier.startEdit,
                child: Text(
                  "Chỉnh sửa",
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // Nút Xóa
          Expanded(
            child: SizedBox(
              height: 50.h,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.darkRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                ),
                onPressed: () => notifier.onDelete(context, tx),
                child: Text(
                  "Xóa",
                  style: TextStyle(
                    color: AppColors.bgCard,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // ================== EDIT MODE ==================
    return Row(
      children: [
        // Nút Hủy
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.grey.shade400, width: 1.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: notifier.cancelEdit,
              child: Text(
                "Hủy",
                style: TextStyle(
                  color: Colors.grey.shade700,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        // Nút Lưu thay đổi
        Expanded(
          child: SizedBox(
            height: 50.h,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.r),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Lưu thay đổi",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
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
