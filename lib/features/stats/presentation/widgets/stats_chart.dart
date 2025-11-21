import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category_item.dart';

class StatsChart extends StatelessWidget {
  final List<StatsByCategoryItem> items;

  const StatsChart({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return SizedBox(
        height: 200.h,
        child: const Center(child: Text('Chưa có dữ liệu')),
      );
    }

    return Container(
      height: 220.h,
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
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: items.map((item) {
                  return PieChartSectionData(
                    value: item.percentage * 100,
                    title: '',
                    radius: 50,
                    titleStyle: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            flex: 2,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: items.take(3).map((item) {
                return Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.h),
                  child: Row(
                    children: [
                      Container(
                        width: 12.w,
                        height: 12.w,
                        decoration: BoxDecoration(shape: BoxShape.circle),
                      ),
                      SizedBox(width: 8.w),
                      Expanded(
                        child: Text(
                          item.categoryName,
                          style: TextStyle(
                            fontSize: 12.sp,
                            color: Colors.grey[700],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
