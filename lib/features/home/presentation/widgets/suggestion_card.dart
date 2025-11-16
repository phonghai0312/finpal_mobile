// ignore_for_file: prefer_const_constructors_in_immutables

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:heroicons/heroicons.dart';

class SuggestionCard extends StatelessWidget {
  final String? title;
  final String? message;

  SuggestionCard({super.key, this.title, this.message});

  @override
  Widget build(BuildContext context) {
    if (title == null || message == null) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF4CC),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(color: const Color(0xFFEED890), width: 1),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// ICON
          SizedBox(
            width: 22,
            height: 22,
            child: HeroIcon(
              HeroIcons.sparkles, // ✔ ICON ĐÚNG
              color: AppColors.bgWarning,
              size: 30.sp,
            ),
          ),

          10.horizontalSpace,

          /// TEXT CONTENT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title!,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black,
                  ),
                ),
                4.verticalSpace,
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 13.sp,
                    height: 1.3,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
