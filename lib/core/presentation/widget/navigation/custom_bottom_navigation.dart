// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:heroicons/heroicons.dart';

import '../../../config/routing/app_routes.dart';

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
    HeroIcons.currencyDollar,
    HeroIcons.chartBar,
    HeroIcons.sparkles,
    HeroIcons.user,
  ];

  final List<String> labels = [
    "Trang chủ",
    "Giao dịch",
    "Thống kê",
    "Gợi ý",
    "Cá nhân",
  ];

  final List<String> routes = [
    AppRoutes.home,
    AppRoutes.transactions,
    AppRoutes.stats,
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
      padding: EdgeInsets.symmetric(vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.bgDarkGreen, // nền xanh như mẫu
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32.r),
          topRight: Radius.circular(32.r),
        ),
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
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HeroIcon(
                    icons[index],
                    style: HeroIconStyle.solid,
                    color: isSelected ? Colors.amber : Colors.white,
                    size: 28.w,
                  ),
                  SizedBox(height: 6.h),
                  Text(
                    labels[index],
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      color: isSelected ? Colors.amber : Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
