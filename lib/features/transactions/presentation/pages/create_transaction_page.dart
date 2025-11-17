import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/categories/presentation/provider/category_provider.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction_detail_provider.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

enum TransactionType { expense, income }

final selectedTransactionTypeProvider = StateProvider<TransactionType>(
  (ref) => TransactionType.expense,
);
final selectedCategoryProvider = StateProvider<String?>((ref) => null);
final transactionDateProvider = StateProvider<DateTime>(
  (ref) => DateTime.now(),
);
final transactionTimeProvider = StateProvider<TimeOfDay>(
  (ref) => TimeOfDay.now(),
);

class CreateTransactionPage extends ConsumerWidget {
  const CreateTransactionPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedTransactionTypeProvider);

    final notifier = ref.read(transactionDetailNotifierProvider.notifier);

    // final categoriesAsync = ref.watch(categoriesProvider);
    final selectedCategory = ref.watch(selectedCategoryProvider);
    final transactionDate = ref.watch(transactionDateProvider);
    final transactionTime = ref.watch(transactionTimeProvider);

    final TextEditingController amountController = TextEditingController();
    final TextEditingController descriptionController = TextEditingController();
    final TextEditingController noteController = TextEditingController();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: transactionDate,
        firstDate: DateTime(2000),
        lastDate: DateTime(2101),
      );
      if (picked != null && picked != transactionDate) {
        ref.read(transactionDateProvider.notifier).state = picked;
      }
    }

    Future<void> _selectTime(BuildContext context) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: transactionTime,
      );
      if (picked != null && picked != transactionTime) {
        ref.read(transactionTimeProvider.notifier).state = picked;
      }
    }

    return Scaffold(
      appBar: HeaderWithBack(
        title: 'Tạo giao dịch mới',
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Loại giao dịch',
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Chi tiêu'),
                    selected: selectedType == TransactionType.expense,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                                .read(selectedTransactionTypeProvider.notifier)
                                .state =
                            TransactionType.expense;
                      }
                    },
                    selectedColor: AppColors.darkRed,
                    labelStyle: TextStyle(
                      color: selectedType == TransactionType.expense
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Thu nhập'),
                    selected: selectedType == TransactionType.income,
                    onSelected: (selected) {
                      if (selected) {
                        ref
                                .read(selectedTransactionTypeProvider.notifier)
                                .state =
                            TransactionType.income;
                      }
                    },
                    selectedColor: AppColors.darkGreen,
                    labelStyle: TextStyle(
                      color: selectedType == TransactionType.income
                          ? Colors.white
                          : Colors.black,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 24.h),
            TextFormField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Số tiền',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Mô tả',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: DateFormat('dd/MM/yyyy').format(transactionDate),
                    ),
                    onTap: () => _selectDate(context),
                    decoration: InputDecoration(
                      labelText: 'Ngày',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: TextFormField(
                    readOnly: true,
                    controller: TextEditingController(
                      text: transactionTime.format(context),
                    ),
                    onTap: () => _selectTime(context),
                    decoration: InputDecoration(
                      labelText: 'Giờ',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      suffixIcon: const Icon(Icons.access_time),
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
              ).textTheme.titleMedium?.copyWith(fontSize: 16.sp),
            ),
            SizedBox(height: 8.h),
            // categoriesAsync.when(
            //   data: (categories) {
            //     return Wrap(
            //       spacing: 8.w,
            //       runSpacing: 8.h,
            //       children: categories.map((category) {
            //         return ChoiceChip(
            //           // label: Text(category.displayName),
            //           selected: selectedCategory == category.id,
            //           onSelected: (selected) {
            //             ref.read(selectedCategoryProvider.notifier).state = selected ? category.id : null;
            //           },
            //           selectedColor: AppColors.primaryGreen,
            //           labelStyle: TextStyle(color: selectedCategory == category.id ? Colors.white : Colors.black),
            //           avatar: Icon(_getIconForCategory(category.icon), color: selectedCategory == category.id ? Colors.white : Colors.black),
            //         );
            //       }).toList(),
            //     );
            //   },
            //   loading: () => const CircularProgressIndicator(),
            //   error: (error, stack) => Text('Error loading categories: $error'),
            // ),
            SizedBox(height: 24.h),
            TextFormField(
              controller: noteController,
              decoration: InputDecoration(
                labelText: 'Ghi chú (không bắt buộc)',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 16.h),
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: AppColors.bgWarning,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: Row(
                children: [
                  Icon(Icons.star, color: AppColors.bgWarning, size: 20.sp),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: Text(
                      'Tự động phân loại các giao dịch tương tự "The Coffee House" vào danh mục "Cà phê" trong tương lai',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.bgWarning,
                        fontSize: 12.sp,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // TODO: Implement save new transaction functionality
                      // Need API for this
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Save functionality not implemented yet.',
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryGreen,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Lưu thay đổi',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.typoWhite,
                        fontSize: 14.sp,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 16.w),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      context.pop();
                    },
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Colors.grey),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 14.h),
                    ),
                    child: Text(
                      'Hủy',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.black,
                        fontSize: 14.sp,
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
