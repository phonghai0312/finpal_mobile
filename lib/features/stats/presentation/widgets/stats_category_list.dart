// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_chart_colors.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category_item.dart';

class StatsCategoryList extends StatelessWidget {
  final List<StatsByCategoryItem> items;
  final ValueChanged<StatsByCategoryItem>? onCategoryTap;

  const StatsCategoryList({super.key, required this.items, this.onCategoryTap});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top 3 danh mục',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.w400,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Wrap(
          spacing: 8.w, // Spacing between chips
          runSpacing: 8.h, // Spacing between rows of chips
          children: items.take(3).map((item) => item).toList().asMap().entries.map((entry) {
            final index = entry.key;
            final item = entry.value;
            final color = AppChartColors.colors[index % AppChartColors.colors.length];
            return GestureDetector(
              onTap: onCategoryTap != null ? () => onCategoryTap!(item) : null,
              child: Chip(
                label: Text(
                  item.categoryName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: color,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                backgroundColor: color.withOpacity(0.1),
                side: BorderSide(color: color.withOpacity(0.5)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
