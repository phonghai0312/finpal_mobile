import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class Button extends StatelessWidget {
  const Button({
    super.key,
    required this.text,
    this.color,
    required this.onPressed,
  });

  final String text;
  final Color? color;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final bool isDisabled = onPressed == null;

    return SizedBox(
      width: double.infinity,
      height: 50.w,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: isDisabled
              ? AppColors.bgDisable
              : (color ?? AppColors.bgDarkGreen),
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 8.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.r),
          ),
          elevation: isDisabled ? 0 : 5,
        ),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.typoWhite,
          ),
        ),
      ),
    );
  }
}
