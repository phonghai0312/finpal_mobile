// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category.notifier.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_form_notifier.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';

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

  void _syncControllers(Budget? budget) {
    if (budget == null) return;

    _amountController.text = budget.amount.toString();
    _alertThresholdController.text = budget.alertThreshold.toString();
    _startDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.fromMillisecondsSinceEpoch(budget.startDate * 1000));
    _endDateController.text = DateFormat(
      'dd/MM/yyyy',
    ).format(DateTime.fromMillisecondsSinceEpoch(budget.endDate * 1000));
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(budgetFormNotifierProvider);
    final categoryState = ref.watch(categoryNotifierProvider);

    ref.listen<BudgetFormState>(budgetFormNotifierProvider, (prev, next) {
      if (next.budget != prev?.budget) {
        _syncControllers(next.budget);
      }

      if (next.isSuccess && (prev == null || !prev.isSuccess)) {
        context.pop();
      }
    });

    final isEditing = widget.budgetId != null;

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      body: SafeArea(
        child: Column(
          children: [
            /// HEADER
            HeaderWithBack(
              title: isEditing ? 'Chỉnh sửa ngân sách' : 'Tạo ngân sách',
              onBack: () => context.go(AppRoutes.home),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.all(16.w),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _summaryCard(state),
                      16.verticalSpace,
                      _formCard(state, categoryState),
                      24.verticalSpace,
                      _actionButtons(isEditing, state),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUMMARY
  // ---------------------------------------------------------------------------

  Widget _summaryCard(BudgetFormState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            state.categoryName ?? 'Chưa chọn danh mục',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
            ),
          ),
          6.verticalSpace,
          Row(
            children: [
              _chip(
                Icons.repeat,
                state.period == BudgetPeriod.monthly
                    ? 'Hàng tháng'
                    : 'Hàng tuần',
              ),
              12.horizontalSpace,
              _chip(
                Icons.warning_amber_rounded,
                '${_alertThresholdController.text.isEmpty ? '--' : _alertThresholdController.text}%',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _chip(IconData icon, String text) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20.r),
      ),
      child: Row(
        children: [
          Icon(icon, size: 14.sp, color: Colors.white),
          6.horizontalSpace,
          Text(
            text,
            style: TextStyle(color: Colors.white, fontSize: 13.sp),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FORM CARD
  // ---------------------------------------------------------------------------

  Widget _formCard(BudgetFormState state, CategoryState categoryState) {
    final notifier = ref.read(budgetFormNotifierProvider.notifier);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _sectionTitle('Thông tin ngân sách'),
          16.verticalSpace,

          /// CATEGORY
          DropdownButtonFormField<String>(
            value: state.categoryId,
            decoration: _inputDecoration('Danh mục'),
            items: categoryState.categories
                .map(
                  (c) =>
                      DropdownMenuItem(value: c.id, child: Text(c.displayName)),
                )
                .toList(),
            onChanged: (id) {
              final c = categoryState.categories.firstWhere((e) => e.id == id);
              notifier.setCategory(id: c.id, name: c.displayName);
            },
            validator: (v) => v == null ? 'Vui lòng chọn danh mục' : null,
          ),

          16.verticalSpace,

          _textField(
            controller: _amountController,
            label: 'Hạn mức chi tiêu',
            keyboardType: TextInputType.number,
          ),

          16.verticalSpace,

          DropdownButtonFormField<String>(
            value: state.period.name,
            decoration: _inputDecoration('Kỳ hạn'),
            items: const [
              DropdownMenuItem(value: 'monthly', child: Text('Hàng tháng')),
              DropdownMenuItem(value: 'weekly', child: Text('Hàng tuần')),
            ],
            onChanged: (v) {
              notifier.setPeriod(BudgetPeriod.values.byName(v!));
            },
          ),

          16.verticalSpace,

          Row(
            children: [
              Expanded(
                child: _dateField(
                  label: 'Ngày bắt đầu',
                  controller: _startDateController,
                  onTap: () => _pickDate(context, true),
                ),
              ),
              12.horizontalSpace,
              Expanded(
                child: _dateField(
                  label: 'Ngày kết thúc',
                  controller: _endDateController,
                  onTap: () => _pickDate(context, false),
                ),
              ),
            ],
          ),

          16.verticalSpace,

          _textField(
            controller: _alertThresholdController,
            label: 'Ngưỡng cảnh báo (%)',
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTION BUTTONS
  // ---------------------------------------------------------------------------

  Widget _actionButtons(bool isEditing, BudgetFormState state) {
    final notifier = ref.read(budgetFormNotifierProvider.notifier);

    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
              padding: EdgeInsets.symmetric(vertical: 14.h),
            ),
            onPressed: state.isLoading
                ? null
                : () {
                    if (_formKey.currentState!.validate()) {
                      final amount = double.parse(_amountController.text);
                      final threshold = double.parse(
                        _alertThresholdController.text,
                      );

                      isEditing
                          ? notifier.updateBudget(
                              budgetId: widget.budgetId!,
                              amount: amount,
                              alertThreshold: threshold,
                            )
                          : notifier.createBudget(
                              amount: amount,
                              alertThreshold: threshold,
                            );
                    }
                  },
            child: Text(
              isEditing ? 'Lưu thay đổi' : 'Tạo ngân sách',
              style: TextStyle(fontSize: 15.sp),
            ),
          ),
        ),
        12.verticalSpace,
        SizedBox(
          width: double.infinity,
          child: OutlinedButton(
            onPressed: () => context.pop(),
            child: const Text('Hủy'),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // HELPERS
  // ---------------------------------------------------------------------------

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12.r)),
      filled: true,
      fillColor: Colors.white,
    );
  }

  Widget _textField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: _inputDecoration(label),
      validator: (v) => v == null || v.isEmpty ? 'Không được để trống' : null,
    );
  }

  Widget _dateField({
    required String label,
    required TextEditingController controller,
    required VoidCallback onTap,
  }) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: _inputDecoration(
        label,
      ).copyWith(suffixIcon: const Icon(Icons.calendar_today)),
      onTap: onTap,
    );
  }

  Future<void> _pickDate(BuildContext context, bool isStart) async {
    final picked = await showDatePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      initialDate: DateTime.now(),
    );
    if (picked == null) return;

    final text = DateFormat('dd/MM/yyyy').format(picked);
    if (isStart) {
      _startDateController.text = text;
      ref
          .read(budgetFormNotifierProvider.notifier)
          .setStartDate(picked.millisecondsSinceEpoch ~/ 1000);
    } else {
      _endDateController.text = text;
      ref
          .read(budgetFormNotifierProvider.notifier)
          .setEndDate(picked.millisecondsSinceEpoch ~/ 1000);
    }
  }

  Widget _sectionTitle(String text) {
    return Text(
      text,
      style: TextStyle(
        fontSize: 16.sp,
        fontWeight: FontWeight.w700,
        color: AppColors.typoHeading,
      ),
    );
  }
}
