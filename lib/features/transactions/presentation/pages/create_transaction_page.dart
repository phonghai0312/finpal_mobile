// ignore_for_file: use_build_context_synchronously, sized_box_for_whitespace, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/button/button.dart';
import 'package:intl/intl.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category.notifier.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';
import '../provider/createtransaction/create_transaction_provider.dart';
import '../provider/createtransaction/create_transaction_notifier.dart';
import '../../../../../core/config/routing/app_routes.dart';

class CreateTransactionPage extends ConsumerStatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  CreateTransactionPageState createState() => CreateTransactionPageState();
}

class CreateTransactionPageState extends ConsumerState<CreateTransactionPage> {
  @override
  Widget build(BuildContext context) {
    final state = ref.watch(createTransactionNotifierProvider);
    final notifier = ref.read(createTransactionNotifierProvider.notifier);
    final categoryState = ref.watch(categoryNotifierProvider);
    final categoryNotifier = ref.read(categoryNotifierProvider.notifier);

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
              controller: notifier.amountController,
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 16.h),

            _inputField(
              label: "Mô tả",
              controller: notifier.descriptionController,
            ),

            SizedBox(height: 16.h),
            _dateTimeRow(context, state, notifier),

            SizedBox(height: 28.h),

            /// ========================
            /// DANH MỤC
            /// ========================
            _sectionTitle("Chọn danh mục"),
            SizedBox(height: 12.h),
            _categorySelector(
              state,
              notifier,
              categoryState,
              () => categoryNotifier.fetchCategories(),
            ),

            SizedBox(height: 28.h),

            /// ========================
            /// GHI CHÚ
            /// ========================
            _sectionTitle("Ghi chú"),
            SizedBox(height: 12.h),

            _inputField(
              label: "Ghi chú (không bắt buộc)",
              controller: notifier.noteController,
              maxLines: 3,
            ),

            SizedBox(height: 28.h),

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
            child: SizedBox(
              width: 180.w,
              height: 44.h,
              child: ChoiceChip(
                label: Text(
                  "Chi tiêu",
                  style: TextStyle(
                    fontSize: 18.sp,
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
        ),
        SizedBox(width: 14.w),
        Expanded(
          child: Container(
            height: 46.h,
            child: SizedBox(
              width: 180.w,
              height: 44.h,
              child: ChoiceChip(
                label: Text(
                  "Thu nhập",
                  style: TextStyle(
                    fontSize: 18.sp,
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
    CategoryState categoryState,
    VoidCallback onRetry,
  ) {
    if (categoryState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (categoryState.errorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Không thể tải danh mục: ${categoryState.errorMessage}',
            style: TextStyle(color: AppColors.typoError, fontSize: 13.sp),
          ),
          TextButton(onPressed: onRetry, child: const Text('Thử lại')),
        ],
      );
    }

    final categories = categoryState.categories;
    if (categories.isEmpty) {
      return Text(
        'Chưa có danh mục nào, hãy tạo mới trước khi ghi giao dịch.',
        style: TextStyle(fontSize: 13.sp, color: AppColors.typoBody),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: categories.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 12.h,
        crossAxisSpacing: 12.w,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final category = categories[index];
        final color = _categoryColor(index);
        final isSelected = category.id == state.categoryId;

        return GestureDetector(
          onTap: () => notifier.setCategory(category.id),
          child: Container(
            padding: EdgeInsets.symmetric(vertical: 12.h),
            decoration: BoxDecoration(
              color: isSelected ? color.withOpacity(0.12) : Colors.white,
              border: Border.all(
                color: isSelected ? color : Colors.grey.shade300,
                width: isSelected ? 2.w : 1.w,
              ),
              borderRadius: BorderRadius.circular(16.r),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 40.w,
                  height: 40.w,
                  decoration: BoxDecoration(
                    color: isSelected ? color : color.withOpacity(0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    _categoryIcon(category.icon),
                    size: 18.sp,
                    color: isSelected ? Colors.white : color,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  category.displayName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? color : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  IconData _categoryIcon(String? iconName) {
    const fallback = Icons.category;
    if (iconName == null) return fallback;
    switch (iconName) {
      case 'fastfood':
        return Icons.fastfood;
      case 'shopping_bag':
        return Icons.shopping_bag;
      case 'attach_money':
        return Icons.attach_money;
      case 'directions_car':
        return Icons.directions_car;
      case 'medical_services':
        return Icons.medical_services;
      case 'home':
        return Icons.home;
      case 'favorite':
        return Icons.favorite;
      case 'local_cafe':
        return Icons.local_cafe;
      case 'water_drop':
        return Icons.water_drop;
      case 'flash_on':
        return Icons.flash_on;
      default:
        return fallback;
    }
  }

  Color _categoryColor(int index) {
    const palette = [
      AppColors.primaryGreen,
      AppColors.bgWarning,
      AppColors.bgDarkGreen,
      AppColors.darkRed,
      AppColors.lightGreen,
      AppColors.bgInfo,
      AppColors.bgError,
    ];
    return palette[index % palette.length];
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
        style: TextStyle(fontSize: 18),
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
