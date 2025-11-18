import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_notifier.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_provider.dart';
import 'package:intl/intl.dart';

// Removed: enum TransactionType { expense, income }
// Removed: selectedTransactionTypeProvider
// Removed: selectedCategoryProvider
// Removed: transactionDateProvider
// Removed: transactionTimeProvider

class CreateTransactionPage extends ConsumerStatefulWidget {
  const CreateTransactionPage({super.key});

  @override
  ConsumerState<CreateTransactionPage> createState() => _CreateTransactionPageState();
}

class _CreateTransactionPageState extends ConsumerState<CreateTransactionPage> {
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(transactionDetailNotifierProvider.notifier).init();
    });
  }

  @override
  void didUpdateWidget(covariant CreateTransactionPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    final transactionDetailState = ref.read(transactionDetailNotifierProvider);
    _amountController.text = transactionDetailState.form.amount > 0
        ? transactionDetailState.form.amount.toString()
        : '';
    _descriptionController.text = transactionDetailState.form.description ?? '';
    _noteController.text = transactionDetailState.form.userNote ?? '';
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
    final transactionDetailState = ref.watch(transactionDetailNotifierProvider);
    final notifier = ref.read(transactionDetailNotifierProvider.notifier);
    final categoriesState = ref.watch(categoryNotifierProvider);

    _amountController.text = transactionDetailState.form.amount > 0
        ? transactionDetailState.form.amount.toString()
        : '';
    _descriptionController.text = transactionDetailState.form.description ?? '';
    _noteController.text = transactionDetailState.form.userNote ?? '';

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: transactionDetailState.form.occurredAtDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryGreen, // header background color
                onPrimary: AppColors.typoWhite, // header text color
                onSurface: AppColors.typoBlack, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != transactionDetailState.form.occurredAtDate) {
        notifier.updateOccurredAtDate(picked);
      }
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: transactionDetailState.form.occurredAtTime,
        builder: (context, child) {
          return Theme(
            data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(
                primary: AppColors.primaryGreen, // header background color
                onPrimary: AppColors.typoWhite, // header text color
                onSurface: AppColors.typoBlack, // body text color
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: AppColors.primaryGreen, // button text color
                ),
              ),
            ),
            child: child!,
          );
        },
      );
      if (picked != null && picked != transactionDetailState.form.occurredAtTime) {
        notifier.updateOccurredAtTime(picked);
      }
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: transactionDetailState.data == null
            ? 'Tạo giao dịch mới'
            : 'Chỉnh sửa giao dịch',
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loại giao dịch',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.typoHeading,
                  ),
            ),
            SizedBox(height: 12.h),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: Padding( // Added Padding
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w), // Added Padding
                      child: const Text('Chi tiêu'),
                    ),
                    selected: transactionDetailState.form.type == TransactionType.expense,
                    onSelected: (selected) {
                      if (selected) {
                        notifier.updateType(TransactionType.expense);
                      }
                    },
                    selectedColor: AppColors.darkRed,
                    backgroundColor: AppColors.bgWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: transactionDetailState.form.type == TransactionType.expense
                            ? AppColors.darkRed
                            : AppColors.bgGray.withOpacity(0.5),
                      ),
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: transactionDetailState.form.type == TransactionType.expense
                          ? AppColors.typoWhite
                          : AppColors.typoBody,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ChoiceChip(
                    label: Padding( // Added Padding
                      padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w), // Added Padding
                      child: const Text('Thu nhập'),
                    ),
                    selected: transactionDetailState.form.type == TransactionType.income,
                    onSelected: (selected) {
                      if (selected) {
                        notifier.updateType(TransactionType.income);
                      }
                    },
                    selectedColor: AppColors.darkGreen,
                    backgroundColor: AppColors.bgWhite,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                      side: BorderSide(
                        color: transactionDetailState.form.type == TransactionType.income
                            ? AppColors.darkGreen
                            : AppColors.bgGray.withOpacity(0.5),
                      ),
                    ),
                    labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: transactionDetailState.form.type == TransactionType.income
                          ? AppColors.typoWhite
                          : AppColors.typoBody,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            TextFormField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              onChanged: notifier.updateAmount,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
              decoration: InputDecoration(
                labelText: 'Số tiền',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: AppColors.bgWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _descriptionController,
              onChanged: notifier.updateDescription,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
              decoration: InputDecoration(
                labelText: 'Mô tả',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: AppColors.bgWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(transactionDetailState.form.occurredAtDate),
                    ),
                    onTap: () => _selectDate(context),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
                    decoration: InputDecoration(
                      labelText: 'Ngày',
                      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: AppColors.bgWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      suffixIcon: Icon(Icons.calendar_today, color: AppColors.typoBody),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: transactionDetailState.form.occurredAtTime.format(context),
                    ),
                    onTap: () => _selectTime(context),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
                    decoration: InputDecoration(
                      labelText: 'Giờ',
                      labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      filled: true,
                      fillColor: AppColors.bgWhite,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                        borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                      ),
                      contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
                      suffixIcon: Icon(Icons.access_time, color: AppColors.typoBody),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            Text(
              'Chọn danh mục',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.typoHeading,
                  ),
            ),
            SizedBox(height: 12.h),
            categoriesState.isLoading
                ? const CircularProgressIndicator()
                : categoriesState.errorMessage != null
                    ? Text('Error loading categories: ${categoriesState.errorMessage}')
                    : Wrap(
                        spacing: 8.w,
                        runSpacing: 8.h,
                        children: categoriesState.categories.map((category) {
                          return ChoiceChip(
                            label: Padding( // Added Padding
                              padding: EdgeInsets.symmetric(vertical: 4.h, horizontal: 8.w), // Added Padding
                              child: Text(category.displayName),
                            ),
                            selected: transactionDetailState.form.categoryId == category.id,
                            onSelected: (selected) {
                              notifier.updateCategory(selected ? category.id : null);
                            },
                            selectedColor: AppColors.primaryGreen,
                            backgroundColor: AppColors.bgWhite,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.r),
                              side: BorderSide(
                                color: transactionDetailState.form.categoryId == category.id
                                    ? AppColors.primaryGreen
                                    : AppColors.bgGray.withOpacity(0.5),
                              ),
                            ),
                            labelStyle: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: transactionDetailState.form.categoryId == category.id ? AppColors.typoWhite : AppColors.typoBody,
                              fontWeight: FontWeight.w600,
                            ),
                            avatar: (category.icon != null)
                                ? Icon(_getIconForCategory(category.icon), color: transactionDetailState.form.categoryId == category.id ? AppColors.typoWhite : AppColors.typoBody)
                                : null,
                          );
                        }).toList(),
                      ),
            SizedBox(height: 24.h),
            TextFormField(
              controller: _noteController,
              onChanged: notifier.updateUserNote,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
              decoration: InputDecoration(
                labelText: 'Ghi chú (không bắt buộc)',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                floatingLabelBehavior: FloatingLabelBehavior.always,
                filled: true,
                fillColor: AppColors.bgWhite,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 24.h), // Increased spacing
            Container(
              padding: EdgeInsets.all(16.w), // Increased padding
              decoration: BoxDecoration(
                color: AppColors.bgInfo.withOpacity(0.1), // Changed to bgInfo with opacity
                borderRadius: BorderRadius.circular(12.r), // Increased border radius
                border: Border.all(color: AppColors.bgInfo), // Added border
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb_outline, color: AppColors.bgInfo, size: 24.sp), // Changed icon and size
                  SizedBox(width: 12.w), // Increased spacing
                  Expanded(
                    child: Text(
                      'Mẹo: Tự động phân loại các giao dịch tương tự vào danh mục này trong tương lai.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.typoBody,
                        fontSize: 13.sp, // Adjusted font size
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32.h), // Increased spacing
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: transactionDetailState.isLoading
                        ? null
                        : () => notifier.saveTransaction(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h), // Increased padding
                      elevation: 4, // Added elevation
                      shadowColor: AppColors.primaryGreen.withOpacity(0.3), // Added shadow color
                    ),
                    child: Text(
                      transactionDetailState.data == null
                          ? 'Tạo giao dịch'
                          : 'Lưu thay đổi',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.typoWhite,
                        fontSize: 16.sp, // Adjusted font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      notifier.onBack(context);
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.bgGray.withOpacity(0.5)), // Adjusted border color
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16.h), // Increased padding
                    ),
                    child: Text(
                      'Hủy',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.typoBody,
                        fontSize: 16.sp, // Adjusted font size
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  IconData _getIconForCategory(String? iconName) {
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
      default:
        return Icons.category;
    }
  }
}
