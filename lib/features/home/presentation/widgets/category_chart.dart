// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../stats/domain/entities/stats_by_category.dart';

class CategoryChart extends StatelessWidget {
  final StatsByCategory? statsByCategory;

  const CategoryChart({super.key, this.statsByCategory});

  @override
  Widget build(BuildContext context) {
    final stats = statsByCategory;

    return Container(
      width: double.infinity,
      height: 220.h,
      padding: EdgeInsets.only(top: 24.h, right: 8.w, bottom: 8.h, left: 8.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: stats == null
          ? const Center(child: CircularProgressIndicator())
          : Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  flex: 6,
                  child: PieChart(
                    PieChartData(
                      startDegreeOffset: -90,
                      sectionsSpace: 0,
                      centerSpaceRadius: 55.w, // tạo vòng tròn mỏng hơn
                      sections: stats.items.map((item) {
                        return PieChartSectionData(
                          value: item.totalAmount,
                          color: item.color,
                          radius: 10.w, // tô dày theo đúng hình
                          showTitle: false,
                          borderSide: BorderSide(color: Colors.black, width: 1),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                8.horizontalSpace,

                /// 📌 LEGEND
                Expanded(
                  flex: 4,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: stats.items.map((item) {
                      return Padding(
                        padding: EdgeInsets.only(bottom: 10.h),
                        child: Row(
                          children: [
                            Container(
                              width: 12.w,
                              height: 12.w,
                              decoration: BoxDecoration(
                                color: item.color,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Colors.black,
                                  width: 1,
                                ),
                              ),
                            ),
                            8.horizontalSpace,
                            Text(
                              item.categoryName,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w500,
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
