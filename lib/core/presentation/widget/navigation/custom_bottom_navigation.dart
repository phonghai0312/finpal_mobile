// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

import '../../../config/routing/app_routes.dart';
import '../../theme/app_colors.dart';

class CustomBottomNavBar extends StatefulWidget {
  final int initialIndex;

  const CustomBottomNavBar({super.key, required this.initialIndex});

  @override
  _CustomBottomNavBarState createState() => _CustomBottomNavBarState();
}

class _CustomBottomNavBarState extends State<CustomBottomNavBar> {
  late int currentIndex;

  final List<HeroIcons> icons = [
    HeroIcons.home,
    HeroIcons.phone,
    HeroIcons.clipboardDocumentCheck,
    HeroIcons.clock,
    HeroIcons.bell,
  ];

  final List<String> routes = [
    AppRoutes.home,
    AppRoutes.transactions,
    AppRoutes.analytics,
    AppRoutes.suggestions,
    AppRoutes.profile,
  ];

  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 14.h),
      decoration: BoxDecoration(
        color: AppColors.bgWhite,
        boxShadow: [BoxShadow(color: AppColors.bgWhite, blurRadius: 4.r)],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(icons.length, (index) {
          final isSelected = index == currentIndex;
          return GestureDetector(
            onTap: () {
              setState(() => currentIndex = index);
              context.go(routes[index]);
            },
            child: Container(
              padding: EdgeInsets.only(
                top: 4.w,
                bottom: 12.w,
                left: 8.w,
                right: 8.w,
              ),
              child: HeroIcon(
                icons[index],
                style: HeroIconStyle.outline,
                color: isSelected ? AppColors.typoPrimary : AppColors.typoBody,
                size: 28.w,
              ),
            ),
          );
        }),
      ),
    );
  }
}
