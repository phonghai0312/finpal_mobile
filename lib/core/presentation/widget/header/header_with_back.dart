import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../../core/presentation/theme/app_colors.dart';

class HeaderWithBack extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  final VoidCallback? onMore;

  const HeaderWithBack({
    super.key,
    required this.title,
    this.onBack,
    this.onMore,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: AppColors.typoWhite,
      // Title
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.typoBlack,
        ),
      ),

      // Back icon
      leading: InkWell(
        borderRadius: BorderRadius.circular(50.r),
        onTap: onBack,
        child: Padding(
          padding: EdgeInsets.all(10.w),
          child: const HeroIcon(
            HeroIcons.chevronLeft,
            style: HeroIconStyle.solid,
            color: AppColors.typoBody,
            size: 22,
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
