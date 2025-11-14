import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';

class OAuthButton extends StatelessWidget {
  final String text;
  final String iconPath;
  final VoidCallback? onPressed;

  const OAuthButton({
    super.key,
    required this.text,
    required this.iconPath,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          height: 44.h,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon
              SizedBox(width: 8.w),

              // Text
              Text(
                text,
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w500,
                  color: AppColors.typoHeading,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
