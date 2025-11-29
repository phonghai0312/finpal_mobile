// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_form_notifier.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category.notifier.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class BudgetFormPage extends ConsumerStatefulWidget {
  final String? budgetId;

  const BudgetFormPage({super.key, this.budgetId});

  @override
  ConsumerState<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends ConsumerState<BudgetFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _amountController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _alertThresholdController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
    _alertThresholdController = TextEditingController();

    Future.microtask(() {
      if (widget.budgetId != null) {
        ref
            .read(budgetFormNotifierProvider.notifier)
            .loadBudget(widget.budgetId!);
      }
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _alertThresholdController.dispose();
    super.dispose();
  }

  void _updateControllers(Budget? budget) {
    if (budget != null) {
      _amountController.text = budget.amount.toString();
      _startDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(budget.startDate * 1000));
      _endDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(budget.endDate * 1000));
      _alertThresholdController.text = budget.alertThreshold.toString();
    } else {
      _amountController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _alertThresholdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetFormState = ref.watch(budgetFormNotifierProvider);
    final categoryState = ref.watch(categoryNotifierProvider);

    ref.listen<BudgetFormState>(budgetFormNotifierProvider, (previous, next) {
      if (next.budget != previous?.budget) {
        _updateControllers(next.budget);
      }
      if (next.errorMessage != null &&
          next.errorMessage != previous?.errorMessage) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lỗi: ${next.errorMessage}'),
            backgroundColor: Colors.red,
          ),
        );
      }
      if (next.isSuccess && (previous == null || !previous.isSuccess)) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              widget.budgetId == null
                  ? 'Tạo ngân sách thành công!'
                  : 'Cập nhật ngân sách thành công!',
            ),
            backgroundColor: Colors.green,
          ),
        );
        context.pop();
      }
    });

    final isEditing = widget.budgetId != null;
    final showInitialLoading =
        budgetFormState.isLoading && isEditing && budgetFormState.budget == null;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: AppBar(
        title: Text(
          isEditing ? 'Chỉnh sửa ngân sách' : 'Tạo ngân sách mới',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: showInitialLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildSummaryCard(isEditing, budgetFormState),
                    SizedBox(height: 18.h),
                    _buildFormCard(
                      context,
                      budgetFormState,
                      categoryState,
                    ),
                    SizedBox(height: 24.h),
                    _buildActionButtons(
                      context: context,
                      isEditing: isEditing,
                      budgetFormState: budgetFormState,
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSummaryCard(bool isEditing, BudgetFormState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF34D399), Color(0xFF059669)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Cập nhật ngân sách' : 'Ngân sách mới',
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
              fontSize: 16.sp,
            ),
          ),
          SizedBox(height: 6.h),
          Text(
            state.categoryName ?? 'Chưa chọn danh mục',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _summaryChip(
                icon: Icons.repeat,
                label: 'Kỳ hạn',
                value: state.period == BudgetPeriod.monthly
                    ? 'Hàng tháng'
                    : 'Hàng tuần',
              ),
              _summaryChip(
                icon: Icons.warning_amber_rounded,
                label: 'Ngưỡng',
                value: state.budget?.alertThreshold != null ||
                        _alertThresholdController.text.isNotEmpty
                    ? '${_alertThresholdController.text.isNotEmpty ? _alertThresholdController.text : state.budget?.alertThreshold ?? 0}%'
                    : '---',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _summaryChip({
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Row(
      children: [
        Container(
          padding: EdgeInsets.all(10.w),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: Colors.white),
        ),
        SizedBox(width: 10.w),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 12.sp)),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFormCard(
    BuildContext context,
    BudgetFormState budgetFormState,
    CategoryState categoryState,
  ) {
    final notifier = ref.read(budgetFormNotifierProvider.notifier);
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        borderRadius: BorderRadius.circular(18.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12.r,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Thông tin chi tiết', style: _sectionTitleStyle()),
          SizedBox(height: 16.h),
          _buildCategoryDropdown(
            categoryState: categoryState,
            selectedId: budgetFormState.categoryId,
            onChanged: (value) {
              if (value == null) return;
              final category = categoryState.categories.firstWhere(
                (element) => element.id == value,
              );
              notifier.setCategory(id: category.id, name: category.displayName);
            },
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            controller: _amountController,
            label: 'Hạn mức chi tiêu',
            hint: 'Ví dụ: 1.500.000',
            keyboardType: TextInputType.number,
            validator: (value) =>
                value == null || double.tryParse(value) == null
                    ? 'Vui lòng nhập số tiền hợp lệ'
                    : null,
          ),
          SizedBox(height: 16.h),
          _buildPeriodDropdown(budgetFormState.period.name, (value) {
            if (value == null) return;
            notifier.setPeriod(BudgetPeriod.values.byName(value));
          }),
          SizedBox(height: 16.h),
          Row(
            children: [
              Expanded(
                child: _buildDateField(
                  context,
                  controller: _startDateController,
                  label: 'Ngày bắt đầu',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Chọn ngày bắt đầu' : null,
                  onTap: () => _pickDate(context, isStart: true),
                ),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: _buildDateField(
                  context,
                  controller: _endDateController,
                  label: 'Ngày kết thúc',
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Chọn ngày kết thúc' : null,
                  onTap: () => _pickDate(context, isStart: false),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          _buildInputField(
            controller: _alertThresholdController,
            label: 'Ngưỡng cảnh báo (%)',
            hint: 'Ví dụ: 80',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || int.tryParse(value) == null) {
                return 'Nhập số nguyên hợp lệ';
              }
              final threshold = int.parse(value);
              if (threshold < 0 || threshold > 100) {
                return 'Ngưỡng phải từ 0 đến 100';
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  TextStyle _sectionTitleStyle() {
    return TextStyle(
      fontSize: 16.sp,
      fontWeight: FontWeight.w700,
      color: AppColors.typoHeading,
    );
  }

  Widget _buildCategoryDropdown({
    required CategoryState categoryState,
    required String? selectedId,
    required ValueChanged<String?> onChanged,
  }) {
    if (categoryState.isLoading && categoryState.categories.isEmpty) {
      return const LinearProgressIndicator();
    }

    if (categoryState.errorMessage != null) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Không thể tải danh mục: ${categoryState.errorMessage}',
            style: TextStyle(color: AppColors.bgError, fontSize: 13.sp),
          ),
          TextButton(
            onPressed: () =>
                ref.read(categoryNotifierProvider.notifier).fetchCategories(),
            child: const Text('Thử lại'),
          ),
        ],
      );
    }

    final dropdownItems = categoryState.categories
        .map(
          (category) => DropdownMenuItem<String>(
            value: category.id,
            child: Text(category.displayName),
          ),
        )
        .toList();

    return DropdownButtonFormField<String>(
      value: selectedId,
      decoration: InputDecoration(
        labelText: 'Danh mục',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: AppColors.bgWhite,
      ),
      items: dropdownItems,
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Vui lòng chọn danh mục' : null,
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    String? hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: AppColors.bgWhite,
      ),
      validator: validator,
    );
  }

  Widget _buildPeriodDropdown(
    String currentPeriod,
    void Function(String?) onChanged,
  ) {
    return DropdownButtonFormField<String>(
      value: currentPeriod,
      decoration: InputDecoration(
        labelText: 'Kỳ hạn',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: AppColors.bgWhite,
      ),
      items: const [
        DropdownMenuItem(value: 'monthly', child: Text('Hàng tháng')),
        DropdownMenuItem(value: 'weekly', child: Text('Hàng tuần')),
      ],
      onChanged: onChanged,
      validator: (value) =>
          value == null || value.isEmpty ? 'Vui lòng chọn kỳ hạn' : null,
    );
  }

  Widget _buildDateField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    String? Function(String?)? validator,
    VoidCallback? onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
        filled: true,
        fillColor: AppColors.bgWhite,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: validator,
      onTap: onTap,
    );
  }

  Future<void> _pickDate(BuildContext context, {required bool isStart}) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (pickedDate == null) return;
    final formatted = DateFormat('dd/MM/yyyy').format(pickedDate);
    if (isStart) {
      _startDateController.text = formatted;
      ref
          .read(budgetFormNotifierProvider.notifier)
          .setStartDate(pickedDate.millisecondsSinceEpoch ~/ 1000);
    } else {
      _endDateController.text = formatted;
      ref
          .read(budgetFormNotifierProvider.notifier)
          .setEndDate(pickedDate.millisecondsSinceEpoch ~/ 1000);
    }
  }

  Widget _buildActionButtons({
    required BuildContext context,
    required bool isEditing,
    required BudgetFormState budgetFormState,
  }) {
    final notifier = ref.read(budgetFormNotifierProvider.notifier);
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton.icon(
            icon: budgetFormState.isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.check_circle_outline),
            label: Text(isEditing ? 'Lưu thay đổi' : 'Tạo ngân sách'),
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: EdgeInsets.symmetric(vertical: 14.h),
              textStyle: TextStyle(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            onPressed: budgetFormState.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      final amount = double.parse(_amountController.text);
                      final alertThreshold = double.parse(
                        _alertThresholdController.text,
                      );
                      if (isEditing) {
                        notifier.updateBudget(
                          budgetId: widget.budgetId!,
                          amount: amount,
                          alertThreshold: alertThreshold,
                        );
                      } else {
                        notifier.createBudget(
                          amount: amount,
                          alertThreshold: alertThreshold,
                        );
                      }
                    }
                  },
          ),
        ),
        SizedBox(height: 12.h),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              padding: EdgeInsets.symmetric(vertical: 14.h),
              side: BorderSide(color: AppColors.bgGray.withOpacity(0.4)),
            ),
            onPressed: () => context.pop(),
            child: const Text('Hủy'),
          ),
        ),
      ],
    );
  }
}
