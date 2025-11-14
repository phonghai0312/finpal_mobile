import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/theme/app_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const AuthHeader({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 8.h),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(8.r),
            onTap: () {},
            child: Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 22.sp,
              color: Colors.black87,
            ),
          ),

          SizedBox(width: 6.w),

          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 20.sp,
              fontWeight: FontWeight.w600,
              color: AppColors.typoBlack,
            ),
          ),
        ],
      ),
    );
  }
}
