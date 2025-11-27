// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';
import '../../domain/entities/transaction.dart';
import '../provider/transactiondetail/transaction_detail_notifier.dart';
import '../provider/transactiondetail/transaction_detail_provider.dart';

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

    noteCtrl = TextEditingController();
    merchantCtrl = TextEditingController();

    Future.microtask(() async {
      // chạy init notifier
      final notifier = ref.read(transactionDetailNotifierProvider.notifier);
      await notifier.init();

      // CHỈ đọc state khi data đã có
      final st = ref.read(transactionDetailNotifierProvider);
      if (st.data != null) {
        noteCtrl.text = st.data!.userNote ?? "";
        merchantCtrl.text = st.data!.merchant ?? "";
      }
    });
  }

  @override
  void dispose() {
    noteCtrl.dispose();
    merchantCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(transactionDetailNotifierProvider);
    final notifier = ref.read(transactionDetailNotifierProvider.notifier);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (state.error != null) {
      return Scaffold(
        appBar: const HeaderWithBack(title: "Chi tiết giao dịch"),
        body: Center(child: Text(state.error!)),
      );
    }

    if (state.data == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final tx = state.data!;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: HeaderWithBack(
        title: "Chi tiết giao dịch",
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
        child: Column(
          children: [
            _buildTopCard(tx),
            SizedBox(height: 16.h),

            _buildAIBanner(tx),
            SizedBox(height: 16.h),

            _infoTile(
              "Thời gian",
              _formatDate(tx.occurredAt),
              Icons.access_time,
            ),
            _infoTile("Danh mục", tx.categoryName ?? "", Icons.category),
            _infoTile("Phương thức", tx.source, Icons.account_balance_wallet),

            _editableTile(
              "Địa điểm",
              Icons.location_on_outlined,
              merchantCtrl,
              state.isEditing,
            ),

            _editableTile(
              "Ghi chú",
              Icons.edit_note,
              noteCtrl,
              state.isEditing,
            ),

            SizedBox(height: 20.h),
            _buildBottomButtons(context, notifier, state, tx),
          ],
        ),
      ),
    );
  }

  // =====================================================================
  // TOP CARD
  Widget _buildTopCard(Transaction tx) {
    final isIncome = tx.type == "income";

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: isIncome ? AppColors.lightGreen : AppColors.lightRed,
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 26.r,
            backgroundColor: Colors.white,
            child: Icon(
              isIncome ? Icons.arrow_downward : Icons.arrow_upward,
              color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
              size: 26.sp,
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            "${isIncome ? "+" : "-"}${NumberFormat("#,###", "vi_VN").format(tx.amount)}đ",
            style: TextStyle(
              fontSize: 22.sp,
              fontWeight: FontWeight.w800,
              color: isIncome ? AppColors.darkGreen : AppColors.darkRed,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            tx.merchant ?? "Không xác định",
            style: TextStyle(fontSize: 14.sp, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // AI BANNER
  Widget _buildAIBanner(Transaction tx) {
    if (tx.ai.categorySuggestionId == null) return const SizedBox.shrink();

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4D1),
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.auto_awesome, color: Colors.orange[700]),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(
              "Phân loại tự động bởi AI\n"
              "Giao dịch được AI phân loại: “${tx.categoryName}” "
              "với độ chính xác ${(tx.ai.confidence! * 100).toInt()}%",
              style: TextStyle(fontSize: 13.sp, color: Colors.orange[900]),
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // NORMAL INFO TILE
  Widget _infoTile(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 4.h),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // =====================================================================
  // EDITABLE TILE
  Widget _editableTile(
    String title,
    IconData icon,
    TextEditingController ctrl,
    bool isEditing,
  ) {
    return Container(
      padding: EdgeInsets.all(14.w),
      margin: EdgeInsets.only(bottom: 10.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: Colors.grey.shade300),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.black54, size: 20.sp),
          SizedBox(width: 12.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                ),
                SizedBox(height: 4.h),
                isEditing
                    ? TextField(
                        controller: ctrl,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          isDense: true,
                        ),
                      )
                    : Text(
                        ctrl.text.isEmpty ? " " : ctrl.text,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(
    BuildContext context,
    TransactionDetailNotifier notifier,
    TransactionDetailState state,
    Transaction tx,
  ) {
    final buttonHeight = 50.h; // chuẩn Figma
    final buttonRadius = 20.r;
    final buttonWidth = 185.w; // bạn đang dùng Expanded nên sẽ auto fill

    if (!state.isEditing) {
      return Row(
        children: [
          // ---------------- CHỈNH SỬA ----------------
          Expanded(
            child: SizedBox(
              height: buttonHeight,
              child: OutlinedButton(
                onPressed: notifier.startEdit,
                style: OutlinedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                  padding: EdgeInsets.zero, // FIX tràn
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  side: const BorderSide(
                    color: AppColors.primaryGreen,
                    width: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius),
                  ),
                ),
                child: Text(
                  "Chỉnh sửa",
                  style: TextStyle(
                    color: AppColors.primaryGreen,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),

          SizedBox(width: 12.w),

          // ---------------- XÓA ----------------
          Expanded(
            child: SizedBox(
              height: buttonHeight,
              child: ElevatedButton(
                onPressed: () => notifier.onDelete(context, tx),
                style: ElevatedButton.styleFrom(
                  minimumSize: Size(buttonWidth, buttonHeight),
                  padding: EdgeInsets.zero, // FIX tràn
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  backgroundColor: AppColors.darkRed,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonRadius),
                  ),
                ),
                child: Text(
                  "Xóa",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ),
        ],
      );
    }

    // =================== EDIT MODE ===================
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: OutlinedButton(
              onPressed: notifier.cancelEdit,
              style: OutlinedButton.styleFrom(
                minimumSize: Size(buttonWidth, buttonHeight),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                side: BorderSide(color: Colors.grey.shade400, width: 1),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
              ),
              child: Text(
                "Hủy",
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade700,
                ),
              ),
            ),
          ),
        ),

        SizedBox(width: 12.w),

        Expanded(
          child: SizedBox(
            height: buttonHeight,
            child: ElevatedButton(
              onPressed: () => notifier.onSave(
                context,
                tx.copyWith(
                  merchant: merchantCtrl.text,
                  userNote: noteCtrl.text,
                ),
              ),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(buttonWidth, buttonHeight),
                padding: EdgeInsets.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                backgroundColor: AppColors.darkGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(buttonRadius),
                ),
              ),
              child: Text(
                "Lưu thay đổi",
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16.sp,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // =====================================================================
  String _formatDate(int ts) {
    final dt = DateTime.fromMillisecondsSinceEpoch(ts * 1000);
    return DateFormat("dd/MM/yyyy, HH:mm").format(dt);
  }
}
