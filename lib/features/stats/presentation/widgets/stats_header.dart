import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/presentation/theme/app_colors.dart';

class StatsHeader extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;
  final ValueChanged<int> onMonthChanged;
  final List<int> months;

  const StatsHeader({
    super.key,
    required this.selectedMonth,
    required this.selectedYear,
    required this.onMonthChanged,
    this.months = const [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: AppColors.primaryGreen.withOpacity(0.12)),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thống kê theo danh mục',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.typoHeading,
                ),
              ),
              SizedBox(height: 4.h),
              Text(
                'Năm $selectedYear',
                style: TextStyle(fontSize: 13.sp, color: AppColors.typoBody),
              ),
            ],
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              value: selectedMonth,
              borderRadius: BorderRadius.circular(12.r),
              icon: const Icon(Icons.keyboard_arrow_down),
              items: months
                  .map(
                    (m) => DropdownMenuItem<int>(
                      value: m,
                      child: Text(
                        'Tháng $m',
                        style: TextStyle(
                          fontSize: 15.sp,
                          color: AppColors.typoBody,
                        ),
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (value) {
                if (value != null) onMonthChanged(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
