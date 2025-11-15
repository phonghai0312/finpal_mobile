import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack; // null = không có nút back

  const AuthHeader({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          /// Tiêu đề
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 25.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.typoBlack,
            ),
          ),
        ],
      ),
    );
  }
}
