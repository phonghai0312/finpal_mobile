import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category_item.dart';

class StatsCategoryList extends StatelessWidget {
  final List<StatsByCategoryItem> items;
  final ValueChanged<StatsByCategoryItem>? onCategoryTap;

  const StatsCategoryList({
    super.key,
    required this.items,
    this.onCategoryTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Top 3 danh mục',
          style: TextStyle(
            fontSize: 18.sp,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        SizedBox(height: 12.h),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: items.take(3).map((item) {
            return GestureDetector(
              onTap: onCategoryTap != null ? () => onCategoryTap!(item) : null,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.r),
                  border: Border.all(color: Colors.grey[300]!),
                ),
                child: Text(
                  item.categoryName,
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
