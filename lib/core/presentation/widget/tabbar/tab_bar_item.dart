// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/theme/app_colors.dart';

class TabBarItem extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const TabBarItem({
    super.key,
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final colors = _getColors();

    return Expanded(
      child: InkWell(
        borderRadius: BorderRadius.circular(24.r),
        onTap: onTap,
        child: Container(
          height: 40.h,
          alignment: Alignment.center,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          decoration: BoxDecoration(
            color: selected ? colors['bg'] : Colors.grey.shade200,
            borderRadius: BorderRadius.circular(24.r),
            border: selected
                ? null
                : Border.all(color: Colors.grey.shade300, width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 13.sp,
              fontWeight: FontWeight.w500,
              color: selected ? colors['text'] : AppColors.typoBody,
            ),
          ),
        ),
      ),
    );
  }

  /// Xác định màu theo title
  Map<String, Color> _getColors() {
    switch (title.toLowerCase()) {
      case 'tất cả':
      case 'all':
        return {
          'bg': AppColors.primaryGreen, // xanh đậm
          'text': Colors.white,
        };

      case 'thu nhập':
      case 'income':
        return {
          'bg': AppColors.lightGreen.withOpacity(0.6),
          'text': AppColors.darkGreen,
        };

      case 'chi tiêu':
      case 'expense':
        return {
          'bg': AppColors.lightRed.withOpacity(0.6),
          'text': AppColors.darkRed,
        };

      default:
        return {'bg': AppColors.bgPrimary, 'text': Colors.white};
    }
  }
}
