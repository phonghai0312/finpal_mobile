import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

class StatsOverviewCards extends StatelessWidget {
  final double income;
  final double expense;
  final String currency;

  const StatsOverviewCards({
    super.key,
    required this.income,
    required this.expense,
    required this.currency,
  });

  @override
  Widget build(BuildContext context) {
    final remaining = income - expense;
    final formatter = NumberFormat.currency(locale: 'vi_VN', symbol: 'đ');

    return Container(
      margin: EdgeInsets.symmetric(vertical: 16.h),
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildRow('Thu nhập', income, Colors.black87, formatter),
          SizedBox(height: 12.h),
          _buildRow('Chi tiêu', -expense, Colors.red, formatter),
          const Divider(height: 24),
          _buildRow('Còn lại', remaining, Colors.blue, formatter, isBold: true),
        ],
      ),
    );
  }

  Widget _buildRow(
    String label,
    double amount,
    Color color,
    NumberFormat formatter, {
    bool isBold = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14.sp,
            color: Colors.grey[700],
            fontWeight: isBold ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        Text(
          formatter.format(amount),
          style: TextStyle(
            fontSize: 16.sp,
            color: color,
            fontWeight: isBold ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
