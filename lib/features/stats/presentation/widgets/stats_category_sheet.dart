// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import '../../../transactions/domain/entities/transaction.dart';

class StatsCategorySheet extends StatelessWidget {
  final String title;
  final String monthLabel;
  final Future<List<Transaction>> future;

  const StatsCategorySheet({
    super.key,
    required this.title,
    required this.monthLabel,
    required this.future,
  });

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.75;

    return Container(
      height: height,
      padding: EdgeInsets.only(
        left: 16.w,
        right: 16.w,
        top: 16.h,
        bottom: 16.h + MediaQuery.of(context).padding.bottom,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag bar
          Center(
            child: Container(
              width: 40.w,
              height: 5.h,
              margin: EdgeInsets.only(bottom: 12.h),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.r),
              ),
            ),
          ),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    monthLabel,
                    style: TextStyle(fontSize: 13.sp, color: Colors.grey[600]),
                  ),
                ],
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ],
          ),

          SizedBox(height: 12.h),

          // Content
          Expanded(
            child: FutureBuilder<List<Transaction>>(
              future: future,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final list = snapshot.data!;
                if (list.isEmpty) {
                  return Center(
                    child: Text(
                      "Không có giao dịch trong danh mục này",
                      style: TextStyle(fontSize: 14.sp, color: Colors.grey),
                    ),
                  );
                }

                return ListView.separated(
                  itemCount: list.length,
                  separatorBuilder: (_, __) => Divider(height: 20.h),
                  itemBuilder: (_, index) {
                    final tx = list[index];
                    final isIncome = tx.type == "income";
                    final formatter = NumberFormat.currency(
                      locale: 'vi_VN',
                      symbol: '₫',
                    );

                    return Row(
                      children: [
                        CircleAvatar(
                          radius: 22.r,
                          backgroundColor:
                              (isIncome ? Colors.green : Colors.redAccent)
                                  .withOpacity(0.12),
                          child: Icon(
                            isIncome
                                ? Icons.arrow_downward
                                : Icons.arrow_upward,
                            color: isIncome ? Colors.green : Colors.redAccent,
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx.normalized.title ??
                                    tx.merchant ??
                                    "Giao dịch",
                                style: TextStyle(
                                  fontSize: 15.sp,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                _formatDate(tx.occurredAt),
                                style: TextStyle(
                                  fontSize: 12.sp,
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          "${isIncome ? "+" : "-"}${formatter.format(tx.amount)}",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: isIncome ? Colors.green : Colors.redAccent,
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(int timestampSec) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestampSec * 1000);
    return DateFormat('dd/MM/yyyy • HH:mm').format(date);
  }
}
