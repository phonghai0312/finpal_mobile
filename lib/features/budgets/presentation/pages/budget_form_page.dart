import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_form_notifier.dart';
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
  late final TextEditingController _categoryController;
  late final TextEditingController _amountController;
  late final TextEditingController _startDateController;
  late final TextEditingController _endDateController;
  late final TextEditingController _alertThresholdController;

  @override
  void initState() {
    super.initState();
    _categoryController = TextEditingController();
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
    _categoryController.dispose();
    _amountController.dispose();
    _startDateController.dispose();
    _endDateController.dispose();
    _alertThresholdController.dispose();
    super.dispose();
  }

  void _updateControllers(Budget? budget) {
    if (budget != null) {
      _categoryController.text = budget.categoryName;
      _amountController.text = budget.amount.toString();
      _startDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(budget.startDate * 1000));
      _endDateController.text = DateFormat(
        'dd/MM/yyyy',
      ).format(DateTime.fromMillisecondsSinceEpoch(budget.endDate * 1000));
      _alertThresholdController.text = budget.alertThreshold.toString();
    } else {
      _categoryController.clear();
      _amountController.clear();
      _startDateController.clear();
      _endDateController.clear();
      _alertThresholdController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final budgetFormState = ref.watch(budgetFormNotifierProvider);

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
      if (next.isSuccess && !previous!.isSuccess) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.budgetId == null ? 'Tạo ngân sách mới' : 'Chỉnh sửa ngân sách',
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () => context.pop(),
        ),
      ),
      body: budgetFormState.isLoading && budgetFormState.budget == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: EdgeInsets.all(16.w),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    _buildInputField(
                      controller: _categoryController,
                      label: 'Danh mục',
                      hint: 'Ví dụ: Ăn uống',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng nhập danh mục'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      controller: _amountController,
                      label: 'Hạn mức chi tiêu',
                      hint: 'Ví dụ: 1000000',
                      keyboardType: TextInputType.number,
                      validator: (value) =>
                          value == null || double.tryParse(value) == null
                          ? 'Vui lòng nhập số tiền hợp lệ'
                          : null,
                    ),
                    SizedBox(height: 16.h),
                    _buildPeriodDropdown(budgetFormState.period.name, (value) {
                      ref
                          .read(budgetFormNotifierProvider.notifier)
                          .setPeriod(BudgetPeriod.values.byName(value!));
                    }),
                    SizedBox(height: 16.h),
                    _buildDateField(
                      context,
                      controller: _startDateController,
                      label: 'Ngày bắt đầu',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng chọn ngày bắt đầu'
                          : null,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          _startDateController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);
                          ref
                              .read(budgetFormNotifierProvider.notifier)
                              .setStartDate(
                                pickedDate.millisecondsSinceEpoch ~/ 1000,
                              );
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildDateField(
                      context,
                      controller: _endDateController,
                      label: 'Ngày kết thúc',
                      validator: (value) => value == null || value.isEmpty
                          ? 'Vui lòng chọn ngày kết thúc'
                          : null,
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                        );
                        if (pickedDate != null) {
                          _endDateController.text = DateFormat(
                            'dd/MM/yyyy',
                          ).format(pickedDate);
                          ref
                              .read(budgetFormNotifierProvider.notifier)
                              .setEndDate(
                                pickedDate.millisecondsSinceEpoch ~/ 1000,
                              );
                        }
                      },
                    ),
                    SizedBox(height: 16.h),
                    _buildInputField(
                      controller: _alertThresholdController,
                      label: 'Ngưỡng cảnh báo (%)',
                      hint: 'Ví dụ: 80',
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || int.tryParse(value) == null) {
                          return 'Vui lòng nhập số nguyên hợp lệ';
                        }
                        final threshold = int.parse(value);
                        if (threshold < 0 || threshold > 100) {
                          return 'Ngưỡng cảnh báo phải từ 0 đến 100';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 24.h),
                    ElevatedButton(
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          final amount = double.parse(_amountController.text);
                          final alertThreshold = double.parse(
                            _alertThresholdController.text,
                          );
                          if (widget.budgetId == null) {
                            ref
                                .read(budgetFormNotifierProvider.notifier)
                                .createBudget(
                                  categoryId:
                                      'mock_category_id', // TODO: Replace with actual category ID
                                  categoryName: _categoryController.text,
                                  amount: amount,
                                  alertThreshold: alertThreshold,
                                );
                          } else {
                            ref
                                .read(budgetFormNotifierProvider.notifier)
                                .updateBudget(
                                  budgetId: widget.budgetId!,
                                  categoryId:
                                      'mock_category_id', // TODO: Replace with actual category ID
                                  categoryName: _categoryController.text,
                                  amount: amount,
                                  alertThreshold: alertThreshold,
                                );
                          }
                        }
                      },
                      child: Text(
                        widget.budgetId == null
                            ? 'Tạo ngân sách'
                            : 'Lưu thay đổi',
                      ),
                    ),
                  ],
                ),
              ),
            ),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
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
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.r)),
        filled: true,
        fillColor: AppColors.bgWhite,
        suffixIcon: const Icon(Icons.calendar_today),
      ),
      validator: validator,
      onTap: onTap,
    );
  }
}
