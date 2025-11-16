import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:heroicons/heroicons.dart';

import '../../../../../core/presentation/theme/app_colors.dart';

class HeaderSimple extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onMore;

  const HeaderSimple({super.key, required this.title, this.onMore});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      automaticallyImplyLeading: false,

      // Title
      title: Text(
        title,
        style: GoogleFonts.poppins(
          fontSize: 18.sp,
          fontWeight: FontWeight.w600,
          color: AppColors.typoBlack,
        ),
      ),

      // More icon
      actions: [
        InkWell(
          borderRadius: BorderRadius.circular(50.r),
          onTap: onMore,
          child: Padding(
            padding: EdgeInsets.all(10.w),
            child: const HeroIcon(
              HeroIcons.ellipsisVertical,
              style: HeroIconStyle.solid,
              color: AppColors.typoBody,
              size: 22,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
