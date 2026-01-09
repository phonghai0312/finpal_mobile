import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/button/button.dart';
import '../../../../../core/presentation/widget/textinput/input_textfield.dart';
import '../../../../../core/utils/validation_auth.dart';
import '../../widget/auth_header.dart';

class ResetPasswordPage extends StatefulWidget {
  const ResetPasswordPage({super.key});

  @override
  State<ResetPasswordPage> createState() => _ResetPasswordPageState();
}

class _ResetPasswordPageState extends State<ResetPasswordPage> {
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmController;
  bool _isValid = false;
  bool _hasPasswordError = false;
  bool _hasConfirmError = false;

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmController = TextEditingController();
    _passwordController.addListener(_validate);
    _confirmController.addListener(_validate);
  }

  @override
  void dispose() {
    _passwordController.removeListener(_validate);
    _confirmController.removeListener(_validate);
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _validate() {
    final pass = _passwordController.text.trim();
    final confirm = _confirmController.text.trim();
    final passValid = ValidationAuth.isStrongPassword(pass);
    final confirmValid = confirm.isNotEmpty && confirm == pass;

    setState(() {
      _hasPasswordError = !passValid && pass.isNotEmpty;
      _hasConfirmError = !confirmValid && confirm.isNotEmpty;
      _isValid = passValid && confirmValid;
    });
  }

  void _confirmReset() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Đổi mật khẩu thành công.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
    context.go(AppRoutes.login);
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
              const AuthHeader(title: 'Đổi mật khẩu'),
              16.verticalSpace,
              Text(
                'Tạo mật khẩu mới cho tài khoản của bạn.',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.typoBody,
                ),
              ),
              20.verticalSpace,
              InputTextField(
                controller: _passwordController,
                label: 'Mật khẩu mới',
                hintText: 'Ít nhất 6 ký tự, có ký tự đặc biệt',
                isPassword: true,
                hasError: _hasPasswordError,
              ),
              14.verticalSpace,
              InputTextField(
                controller: _confirmController,
                label: 'Nhập lại mật khẩu',
                hintText: 'Nhập lại mật khẩu mới',
                isPassword: true,
                hasError: _hasConfirmError,
              ),
              10.verticalSpace,
              Text(
                'Yêu cầu: có chữ hoa, chữ thường và ký tự đặc biệt.',
                style: GoogleFonts.poppins(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.typoBody,
                ),
              ),
              24.verticalSpace,
              Button(
                text: 'Xác nhận',
                onPressed: _isValid ? _confirmReset : null,
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
