// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:heroicons/heroicons.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';

class ActionButtons extends StatelessWidget {
  final VoidCallback? onAddCategory;
  final VoidCallback? onLimitPressed;

  const ActionButtons({super.key, this.onAddCategory, this.onLimitPressed});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _PressableButton(
            onTap: onAddCategory,
            borderColor: AppColors.bgPrimary,
            background: Colors.white,
            child: Column(
              children: [
                HeroIcon(
                  HeroIcons.plus,
                  size: 26.w,
                  color: AppColors.bgPrimary,
                ),
                6.verticalSpace,
                Text(
                  "Thêm danh mục",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),

        12.horizontalSpace,

        Expanded(
          child: _PressableButton(
            onTap: onLimitPressed,
            borderColor: AppColors.bgPrimary,
            background: Colors.white,
            child: Column(
              children: [
                HeroIcon(
                  HeroIcons.currencyDollar,
                  size: 26.w,
                  color: Colors.amber,
                ),
                6.verticalSpace,
                Text(
                  "Hạn mức chi tiêu",
                  style: TextStyle(
                    fontSize: 14.sp,
                    fontWeight: FontWeight.w500,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Widget riêng xử lý hiệu ứng nhấn
class _PressableButton extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final Color background;
  final Color? borderColor;

  const _PressableButton({
    required this.child,
    required this.onTap,
    required this.background,
    this.borderColor,
  });

  @override
  State<_PressableButton> createState() => _PressableButtonState();
}

class _PressableButtonState extends State<_PressableButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: _isPressed
            ? widget.background.withOpacity(0.85) // DARKEN WHEN PRESSED
            : widget.background,
        borderRadius: BorderRadius.circular(16.r),
        border: widget.borderColor != null
            ? Border.all(color: widget.borderColor!, width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16.r),
        child: InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: widget.onTap,
          onTapDown: (_) => setState(() => _isPressed = true),
          onTapCancel: () => setState(() => _isPressed = false),
          onTapUp: (_) => setState(() => _isPressed = false),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 16.h),
            child: widget.child,
          ),
        ),
      ),
    );
  }
}
