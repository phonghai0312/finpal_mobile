// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:finpal/features/categories/presentation/provider/category.notifier.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import 'package:finpal/core/presentation/theme/app_colors.dart';
import 'package:finpal/core/presentation/widget/button/button.dart';
import 'package:finpal/core/presentation/widget/header/header_with_back.dart';

import 'package:finpal/features/budgets/presentation/providers/budget_form/budget_form_notifier.dart';
import 'package:finpal/features/budgets/presentation/providers/budget_form/budget_form_provider.dart';
import 'package:finpal/features/categories/presentation/provider/category_provider.dart';

class BudgetFormPage extends ConsumerStatefulWidget {
  const BudgetFormPage({super.key});

  @override
  ConsumerState<BudgetFormPage> createState() => _BudgetFormPageState();
}

class _BudgetFormPageState extends ConsumerState<BudgetFormPage> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _amountController;
  late final TextEditingController _alertController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;

  @override
  void initState() {
    super.initState();

    _amountController = TextEditingController();
    _alertController = TextEditingController();
    _startDateController = TextEditingController();
    _endDateController = TextEditingController();
  }

  @override
  void dispose() {
    _amountController.dispose();
    _alertController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen<BudgetFormState>(budgetFormNotifierProvider, (prev, next) {
      // 🛑 tránh set lặp vô hạn
      if (prev?.budget?.id == next.budget?.id) return;

      final budget = next.budget;
      if (budget == null) return;

      _amountController.text = NumberFormat.decimalPattern().format(
        budget.amount,
      );

      _alertController.text = budget.alertThreshold.toString();

      _startDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(budget.startDate * 1000));

      _endDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(budget.endDate * 1000));
    });

    final state = ref.watch(budgetFormNotifierProvider);

    if (state.isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final notifier = ref.read(budgetFormNotifierProvider.notifier);
    final categoryState = ref.watch(categoryNotifierProvider);
    final isEditing = state.isEditMode;

    return Scaffold(
      backgroundColor: AppColors.typoWhite,
      body: SafeArea(
        child: Column(
          children: [
            HeaderWithBack(
              title: isEditing ? 'Chỉnh sửa ngân sách' : 'Tạo ngân sách',
              onBack: () => notifier.onBack(context),
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
                      _formCard(state, notifier, categoryState),
                      24.verticalSpace,
                      Button(
                        text: isEditing ? 'Lưu thay đổi' : 'Tạo ngân sách',
                        onPressed: state.isLoading
                            ? null
                            : () {
                                if (!_formKey.currentState!.validate()) return;

                                notifier.submit(
                                  context,
                                  amount: double.parse(
                                    _amountController.text.replaceAll('.', ''),
                                  ),
                                  alertThreshold: double.parse(
                                    _alertController.text.replaceAll('.', ''),
                                  ),
                                );
                              },
                      ),
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

  Widget _summaryCard(BudgetFormState state) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: AppColors.bgDarkGreen,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Text(
        state.categoryName ?? 'Chưa chọn danh mục',
        style: GoogleFonts.poppins(
          color: Colors.white,
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  Widget _formCard(
    BudgetFormState state,
    BudgetFormNotifier notifier,
    CategoryState categoryState,
  ) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          DropdownButtonFormField<String>(
            value: state.categoryId,
            decoration: const InputDecoration(labelText: 'Danh mục'),
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
            validator: (v) => v == null ? 'Chọn danh mục' : null,
          ),
          16.verticalSpace,
          TextFormField(
            controller: _amountController,
            decoration: const InputDecoration(labelText: 'Hạn mức'),
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'Không để trống' : null,
          ),
          16.verticalSpace,
          TextFormField(
            controller: _alertController,
            decoration: const InputDecoration(labelText: 'Cảnh báo (%)'),
            keyboardType: TextInputType.number,
            validator: (v) => v == null || v.isEmpty ? 'Không để trống' : null,
          ),
          16.verticalSpace,
          _dateField('Ngày bắt đầu', _startDateController, (d) {
            notifier.setStartDate(d);
          }),
          16.verticalSpace,
          _dateField('Ngày kết thúc', _endDateController, (d) {
            notifier.setEndDate(d);
          }),
        ],
      ),
    );
  }

  Widget _dateField(
    String label,
    TextEditingController controller,
    void Function(int) onPicked,
  ) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        labelText: label,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
          initialDate: DateTime.now(),
        );
        if (picked == null) return;

        controller.text = DateFormat('dd/MM/yyyy').format(picked);
        onPicked(picked.millisecondsSinceEpoch ~/ 1000);
      },
    );
  }
}
