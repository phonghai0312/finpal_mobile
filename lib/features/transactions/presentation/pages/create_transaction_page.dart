// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/button/button.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';
import '../provider/createtransaction/create_transaction_provider.dart';
import '../provider/createtransaction/create_transaction_notifier.dart';
import '../../../../../core/config/routing/app_routes.dart';

class CreateTransactionPage extends ConsumerStatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  CreateTransactionPageState createState() => CreateTransactionPageState();
}

class CreateTransactionPageState extends ConsumerState<CreateTransactionPage> {
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _noteController;

  @override
  void initState() {
    super.initState();

    final state = ref.read(createTransactionNotifierProvider);
    final notifier = ref.read(createTransactionNotifierProvider.notifier);

    _amountController = TextEditingController(
      text: state.amount?.toString() ?? "",
    );
    _descriptionController = TextEditingController(
      text: state.description ?? "",
    );
    _noteController = TextEditingController(text: state.note ?? "");

    // đồng bộ text → state
    _amountController.addListener(() {
      notifier.setAmount(_amountController.text);
    });
    _descriptionController.addListener(() {
      notifier.setDescription(_descriptionController.text);
    });
    _noteController.addListener(() {
      notifier.setNote(_noteController.text);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _descriptionController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTransactionNotifierProvider);
    final notifier = ref.read(createTransactionNotifierProvider.notifier);

    return Scaffold(
      appBar: HeaderWithBack(
        title: 'Tạo giao dịch mới',
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ========================
            /// LOẠI GIAO DỊCH
            /// ========================
            _sectionTitle("Loại giao dịch"),
            SizedBox(height: 12.h),
            _typeSelector(state, notifier),

            SizedBox(height: 24.h),

            /// ========================
            /// THÔNG TIN CHÍNH
            /// ========================
            _sectionTitle("Thông tin chính"),
            SizedBox(height: 12.h),

            _inputField(
              label: "Số tiền",
              controller: _amountController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),

            _inputField(label: "Mô tả", controller: _descriptionController),

            SizedBox(height: 16.h),
            _dateTimeRow(context, state, notifier),

            SizedBox(height: 28.h),

            /// ========================
            /// DANH MỤC
            /// ========================
            _sectionTitle("Chọn danh mục"),
            SizedBox(height: 12.h),
            _categorySelector(state, notifier),

            SizedBox(height: 28.h),

            /// ========================
            /// GHI CHÚ
            /// ========================
            _sectionTitle("Ghi chú"),
            SizedBox(height: 12.h),

            _inputField(
              label: "Ghi chú (không bắt buộc)",
              controller: _noteController,
              maxLines: 3,
            ),

            SizedBox(height: 28.h),

            /// ========================
            /// RULE TỰ ĐỘNG
            /// ========================
            _autoRuleCard(),

            SizedBox(height: 32.h),

            /// ========================
            /// BUTTON
            /// ========================
            _buttons(context, notifier, state),
          ],
        ),
      ),
    );
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================
  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.bold,
        color: AppColors.typoBlack,
      ),
    );
  }

  // ============================================================
  // TYPE SELECTOR (expense / income)
  // ============================================================
  Widget _typeSelector(
      CreateTransactionState state,
      CreateTransactionNotifier notifier,
      ) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 46.h,
            child: ChoiceChip(
              label: Text(
                "Chi tiêu",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: state.type == "expense"
                      ? AppColors.darkRed
                      : Colors.black87,
                ),
              ),
              selected: state.type == "expense",
              selectedColor: AppColors.lightRed,
              backgroundColor: Colors.grey.shade200,
              onSelected: (_) => notifier.setType("expense"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Container(
            height: 46.h,
            child: ChoiceChip(
              label: Text(
                "Thu nhập",
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: state.type == "income"
                      ? AppColors.darkGreen
                      : Colors.black87,
                ),
              ),
              selected: state.type == "income",
              selectedColor: AppColors.lightGreen,
              backgroundColor: Colors.grey.shade200,
              onSelected: (_) => notifier.setType("income"),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14.r),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
            ),
          ),
        ),
      ],
    );
  }

  // ============================================================
  // INPUT FIELD
  // ============================================================
  Widget _inputField({
    required String label,
    required TextEditingController controller,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      ),
    );
  }

  // ============================================================
  // DATE + TIME PICKERS
  // ============================================================
  Widget _dateTimeRow(
      BuildContext context,
      CreateTransactionState state,
      CreateTransactionNotifier notifier,
      ) {
    return Row(
      children: [
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showDatePicker(
                context: context,
                initialDate: state.date,
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );
              if (picked != null) notifier.setDate(picked);
            },
            child: _readonlyBox(
              "Ngày",
              DateFormat('dd/MM/yyyy').format(state.date),
            ),
          ),
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: InkWell(
            onTap: () async {
              final picked = await showTimePicker(
                context: context,
                initialTime: state.time,
              );
              if (picked != null) notifier.setTime(picked);
            },
            child: _readonlyBox("Giờ", state.time.format(context)),
          ),
        ),
      ],
    );
  }

  Widget _readonlyBox(String label, String value) {
    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600),
          ),
          SizedBox(height: 4.h),
          Text(value, style: TextStyle(fontSize: 14.sp)),
        ],
      ),
    );
  }

  // ============================================================
  // CATEGORY SELECTOR
  // ============================================================
  Widget _categorySelector(
      CreateTransactionState state,
      CreateTransactionNotifier notifier,
      ) {
    final categories = [
      ("c001", "Ăn uống", Icons.fastfood),
      ("c008", "Cà phê", Icons.coffee),
      ("c002", "Mua sắm", Icons.shopping_bag),
      ("c004", "Di chuyển", Icons.directions_car),
      ("c005", "Sức khỏe", Icons.health_and_safety),
      ("c009", "Nhà cửa", Icons.home),
      ("c003", "Lương", Icons.attach_money),
    ];

    return Wrap(
      spacing: 10.w,
      runSpacing: 10.h,
      children: categories.map((c) {
        final selected = c.$1 == state.categoryId;
        return ChoiceChip(
          selected: selected,
          onSelected: (_) => notifier.setCategory(c.$1),
          selectedColor: Colors.blue.shade600,
          avatar: Icon(
            c.$3,
            size: 18.sp,
            color: selected ? Colors.white : Colors.black,
          ),
          label: Text(c.$2),
          labelStyle: TextStyle(
            color: selected ? Colors.white : Colors.black87,
          ),
        );
      }).toList(),
    );
  }

  // ============================================================
  // AUTO RULE CARD
  // ============================================================
  Widget _autoRuleCard() {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: const Text(
        "✨ Áp dụng quy tắc tự động\n"
            "Tự động phân loại các giao dịch tương tự vào danh mục này trong tương lai.",
        style: TextStyle(fontSize: 13),
      ),
    );
  }

  // ============================================================
  // BUTTONS
  // ============================================================
  Widget _buttons(
      BuildContext context,
      CreateTransactionNotifier notifier,
      CreateTransactionState state,
      ) {
    return Row(
      children: [
        Expanded(
          child: Button(
            text: "Lưu thay đổi",
            onPressed: state.isLoading ? null : () => notifier.submit(context),
            color: AppColors.bgDarkGreen,
            textColor: AppColors.typoWhite,
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Button(
            text: "Hủy",
            color: AppColors.bgDisable,
            onPressed: () => context.go(AppRoutes.transactions),
          ),
        ),
      ],
    );
  }
}
