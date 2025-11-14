import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/theme/app_colors.dart';

class AuthFooter extends StatelessWidget {
  final String questionText;
  final String actionText;
  final VoidCallback onActionPressed;
  final String? imagePath; // thêm path logo PNG

  const AuthFooter({
    super.key,
    required this.questionText,
    required this.actionText,
    required this.onActionPressed,
    this.imagePath, // logo đặt ở cuối
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        /// Text tạo tài khoản
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              questionText,
              style: GoogleFonts.poppins(
                fontSize: 14.sp,
                color: AppColors.typoBody,
              ),
            ),
            InkWell(
              borderRadius: BorderRadius.circular(8.r),
              onTap: onActionPressed,
              child: Text(
                actionText,
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.typoPrimary,
                  decoration: TextDecoration.underline,
                  decorationColor: AppColors.typoPrimary,
                ),
              ),
            ),
          ],
        ),

        SizedBox(height: 24.h),

        /// Logo PNG phía dưới
        if (imagePath != null)
          Center(
            child: Image.asset(
              imagePath!,
              width: 255.47.w,
              height: 350.w,
              fit: BoxFit.contain,
            ),
          ),
      ],
    );
  }
}
