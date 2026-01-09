import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/button/button.dart';
import '../../../../../core/presentation/widget/textinput/input_textfield.dart';
import '../../widget/auth_header.dart';

class VerifyOtpPage extends StatefulWidget {
  const VerifyOtpPage({super.key});

  @override
  State<VerifyOtpPage> createState() => _VerifyOtpPageState();
}

class _VerifyOtpPageState extends State<VerifyOtpPage> {
  static const String _fakeOtp = '654321';
  late final TextEditingController _otpController;
  bool _isValid = false;

  @override
  void initState() {
    super.initState();
    _otpController = TextEditingController();
    _otpController.addListener(_validate);
  }

  @override
  void dispose() {
    _otpController.removeListener(_validate);
    _otpController.dispose();
    super.dispose();
  }

  void _validate() {
    final text = _otpController.text.trim();
    final isValid = text.length >= 6;
    if (_isValid != isValid) {
      setState(() => _isValid = isValid);
    }
  }

  void _confirmOtp() {
    final text = _otpController.text.trim();
    final isMatch = text == _fakeOtp;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          isMatch
              ? 'OTP hợp lệ.'
              : 'OTP không đúng. Vui lòng thử lại.',
        ),
        backgroundColor: isMatch ? AppColors.bgSuccess : AppColors.bgError,
        behavior: SnackBarBehavior.floating,
      ),
    );

    if (isMatch) {
      context.go(AppRoutes.resetPassword);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(title: 'Nhập mã OTP'),
              20.verticalSpace,
              Text(
                'Vui lòng nhập mã OTP đã gửi',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.typoBody,
                ),
              ),
              20.verticalSpace,
              InputTextField(
                controller: _otpController,
                label: 'Mã OTP',
                hintText: 'Nhập 6 chữ số',
                hasError: _isValid ? false : _otpController.text.isNotEmpty,
              ),
              24.verticalSpace,
              Button(
                text: 'Xác nhận',
                onPressed: _isValid ? _confirmOtp : null,
                color: AppColors.bgDarkGreen,
              ),
              20.verticalSpace,
              GestureDetector(
                onTap: () => context.go(AppRoutes.login),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Quay lại đăng nhập',
                      style: GoogleFonts.poppins(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                        color: AppColors.bgDarkGreen,
                      ),
                    ),
                    4.horizontalSpace,
                    Icon(
                      Icons.arrow_forward,
                      size: 16.sp,
                      color: AppColors.bgPrimary,
                    ),
                  ],
                ),
              ),
              40.verticalSpace,
              Center(
                child: Image.asset(
                  'assets/image/logo_finpal.png',
                  width: 220.w,
                  height: 300.w,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
