import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/button/button.dart';
import '../../../../../core/presentation/widget/textinput/input_textfield.dart';
import '../../provider/login/login_provider.dart';

import '../../widget/auth_footer.dart';
import '../../widget/auth_header.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(loginNotifierProvider);
    final notifier = ref.read(loginNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgWhite,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 12.h),

              /// Header
              const AuthHeader(title: 'Đăng nhập'),

              SizedBox(height: 20.h),

              /// Main title
              Text(
                'Chào mừng trở lại',
                style: GoogleFonts.poppins(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bgDarkGreen,
                ),
              ),

              SizedBox(height: 6.h),

              /// Subtitle
              Text(
                'Đăng nhập để tiếp tục quản lý tài chính',
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.typoBody,
                ),
              ),

              SizedBox(height: 24.h),

              /// Email field
              InputTextField(
                controller: state.usernameController,
                label: 'Email',
                hintText: 'example@email.com',
                hasError: state.hasUserNameError,
              ),

              SizedBox(height: 14.h),

              /// Password field
              InputTextField(
                controller: state.passwordController,
                label: 'Mật khẩu',
                hintText: 'Ít nhất 8 ký tự',
                isPassword: true,
                hasError: state.hasPasswordError,
              ),

              SizedBox(height: 10.h),

              /// Row Remember + Forgot password
              Row(
                children: [
                  Checkbox(
                    value: state.remember,
                    activeColor: AppColors.bgPrimary,
                    checkColor: Colors.white,
                    onChanged: notifier.toggleRemember,
                  ),

                  Text(
                    'Ghi nhớ đăng nhập',
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      color: AppColors.typoBody,
                    ),
                  ),

                  const Spacer(),

                  InkWell(
                    onTap: () {},
                    child: Text(
                      'Quên mật khẩu?',
                      style: GoogleFonts.poppins(
                        fontSize: 13.sp,
                        color: AppColors.typoPrimary,
                        decoration: TextDecoration.underline,
                        decorationColor: AppColors.typoPrimary,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 26.h),

              /// Login button
              Button(
                text: state.isLoading ? 'Đang xử lý...' : 'Đăng nhập',
                color: AppColors.bgDarkGreen,
                onPressed: state.isValid && !state.isLoading
                    ? () => notifier.onSignIn(context)
                    : null,
              ),

              SizedBox(height: 22.h),

              /// Footer Sign Up
              Center(
                child: AuthFooter(
                  questionText: "Chưa có tài khoản? ",
                  actionText: 'Tạo tài khoản mới',
                  onActionPressed: () {},
                  imagePath: 'assets/image/logo_finpal.png',
                ),
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
