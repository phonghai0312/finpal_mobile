import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../theme/app_colors.dart';

class InputTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hintText;
  final String label;
  final bool isPassword;
  final bool hasError;
  final bool readOnly;
  final Widget? suffixIcon;
  final VoidCallback? onTap;

  const InputTextField({
    super.key,
    required this.controller,
    this.hintText = '',
    this.label = '',
    this.isPassword = false,
    this.hasError = false,
    this.readOnly = false,
    this.suffixIcon,
    this.onTap,
  });

  @override
  State<InputTextField> createState() => _InputTextFieldState();
}

class _InputTextFieldState extends State<InputTextField> {
  bool _isObscured = true;
  bool _showSuffixIcon = false;
  late VoidCallback _textListener;

  @override
  void initState() {
    super.initState();

    // Listen for text changes to toggle suffixIcon visibility
    _textListener = () {
      final shouldShow = widget.controller.text.isNotEmpty;
      if (shouldShow != _showSuffixIcon && mounted) {
        setState(() => _showSuffixIcon = shouldShow);
      }
    };

    widget.controller.addListener(_textListener);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_textListener);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color borderColor = widget.hasError
        ? Colors.red
        : Colors.grey.shade300;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.label.isNotEmpty) ...[
          Text(
            widget.label,
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: AppColors.typoBlack,
            ),
          ),
          SizedBox(height: 6.h),
        ],

        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword ? _isObscured : false,
          readOnly: widget.readOnly,
          onTap: widget.onTap,
          style: GoogleFonts.poppins(
            fontSize: 14.sp,
            color: AppColors.typoHeading,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText.isNotEmpty ? widget.hintText : null,
            hintStyle: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: Colors.grey.shade500,
            ),

            constraints: BoxConstraints(minHeight: 36.h),
            filled: true,
            fillColor: AppColors.bgHover,

            contentPadding: EdgeInsets.symmetric(
              vertical: 12.h,
              horizontal: 12.w,
            ),

            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(color: borderColor, width: 0.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16.r),
              borderSide: BorderSide(
                color: widget.hasError
                    ? Colors.red
                    // ignore: deprecated_member_use
                    : AppColors.typoPrimary.withOpacity(0.5),
                width: 1.8,
              ),
            ),

            // Password visibility icon
            suffixIcon: widget.isPassword
                ? IconButton(
                    icon: Icon(
                      _isObscured
                          ? Icons.visibility_off_outlined
                          : Icons.visibility_outlined,
                      color: Colors.grey,
                      size: 20.sp,
                    ),
                    onPressed: () => setState(() => _isObscured = !_isObscured),
                  )
                : widget.suffixIcon,
          ),
        ),
      ],
    );
  }
}
