// ignore_for_file: deprecated_member_use, dead_code, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';
import '../../domain/entities/transaction.dart';
import '../provider/transactiondetail/transaction_detail_provider.dart';

class TransactionDetailPage extends ConsumerStatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  TransactionDetailPageState createState() => TransactionDetailPageState();
}

class TransactionDetailPageState extends ConsumerState<TransactionDetailPage> {
  @override
  void initState() {
    super.initState();

    /// giống BookingDetailPage
    Future.microtask(() async {
      await ref
          .read(transactionDetailNotifierProvider.notifier)
          .initLoad(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionDetailNotifierProvider);
    final notifier = ref.read(transactionDetailNotifierProvider.notifier);

    return Scaffold(
      appBar: HeaderWithBack(
        title: 'Chi tiết giao dịch',
        onBack: () => notifier.onBack(context),
      ),
      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.bgPrimary),
            );
          }

          if (state.detail == null) {
            return const SizedBox.shrink();
          }

          return RefreshIndicator(
            color: AppColors.bgPrimary,
            onRefresh: () async => notifier.refresh(context),
            child: _buildDetailView(state.detail!, notifier),
          );
        },
      ),
    );
  }

  /// ===============================
  /// MAIN DETAIL VIEW
  /// ===============================
  Widget _buildDetailView(Transaction tx, dynamic notifier) {
    final statusDesign = notifier.getStatusDesign(tx.type);

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeaderSection(tx, statusDesign),
          SizedBox(height: 20.h),

          _buildSectionTitle("Thông tin giao dịch"),
          SizedBox(height: 12.h),

          _buildInfoRow(
            "Số tiền",
            "${tx.type == "income" ? "+" : "-"}${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(tx.amount)}",
          ),
          _buildInfoRow("Thời gian", _formatDate(tx.occurredAt)),
          _buildInfoRow("Danh mục", tx.categoryName ?? "Không xác định"),
          _buildInfoRow("Nguồn", tx.source),
          _buildInfoRow("Địa điểm", tx.merchant ?? "Không xác định"),

          if (tx.userNote != null && tx.userNote!.isNotEmpty)
            _buildInfoRow("Ghi chú", tx.userNote!),

          SizedBox(height: 24.h),
          _buildSectionTitle("Gợi ý từ AI"),
          SizedBox(height: 12.h),
          _buildAIBanner(tx),

          SizedBox(height: 30.h),
          _buildActionButtons(notifier, tx),
        ],
      ),
    );
  }

  /// ===============================
  /// HEADER CARD
  /// ===============================
  Widget _buildHeaderSection(Transaction tx, Map<String, dynamic> statusStyle) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: statusStyle['color'].withOpacity(0.15),
        borderRadius: BorderRadius.circular(14.r),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30.r,
            backgroundColor: Colors.white,
            child: Icon(
              tx.type == "income" ? Icons.arrow_downward : Icons.arrow_upward,
              size: 28.sp,
              color: statusStyle['color'],
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "${tx.type == "income" ? "+" : "-"}${NumberFormat.currency(locale: 'vi_VN', symbol: "₫").format(tx.amount)}",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: statusStyle['color'],
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            tx.merchant ?? "Không rõ địa điểm",
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w500,
              color: AppColors.typoBody,
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// AI BANNER
  /// ===============================
  Widget _buildAIBanner(Transaction tx) {
    if (tx.ai.categorySuggestionId == null || tx.ai.confidence == null) {
      return const SizedBox.shrink();
    }

    final confidencePercent = (tx.ai.confidence! * 100).toInt();

    return Container(
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withOpacity(0.1),
        borderRadius: BorderRadius.circular(10.r),
        border: Border.all(color: AppColors.primaryGreen),
      ),
      child: Row(
        children: [
          Icon(Icons.auto_awesome, color: AppColors.primaryGreen, size: 18.sp),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              'AI đề xuất danh mục: "${tx.categoryName ?? "Không xác định"}" '
              '- Độ tin cậy $confidencePercent%',
              style: TextStyle(
                fontSize: 12.sp,
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// ===============================
  /// INFO ROW
  /// ===============================
  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 6.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(color: AppColors.typoBody, fontSize: 14.sp),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                color: AppColors.typoBlack,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String text) => Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16.sp,
      color: AppColors.typoBlack,
    ),
  );

  /// ===============================
  /// BUTTON
  /// ===============================
  Widget _buildActionButtons(dynamic notifier, Transaction tx) {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: () {
              /// sẽ implement sau
            },
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryGreen),
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Chỉnh sửa',
              style: TextStyle(color: AppColors.primaryGreen, fontSize: 14.sp),
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: ElevatedButton(
            onPressed: () {
              /// sẽ implement
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.darkRed,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
            child: Text(
              'Xóa',
              style: TextStyle(color: AppColors.bgCard, fontSize: 14.sp),
            ),
          ),
        ),
      ],
    );
  }

  /// ===============================
  /// FORMAT DATE
  /// ===============================
  String _formatDate(int seconds) {
    final date = DateTime.fromMillisecondsSinceEpoch(seconds * 1000);

    final today = DateTime.now();
    final yDay = today.subtract(const Duration(days: 1));

    if (date.day == today.day &&
        date.month == today.month &&
        date.year == today.year) {
      return "Hôm nay, ${DateFormat('HH:mm').format(date)}";
    }

    if (date.day == yDay.day &&
        date.month == yDay.month &&
        date.year == yDay.year) {
      return "Hôm qua, ${DateFormat('HH:mm').format(date)}";
    }

    return DateFormat('dd/MM/yyyy, HH:mm').format(date);
  }
}
