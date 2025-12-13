// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/auth/presentation/widget/auth_footer.dart'
    show AuthFooter;

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/textinput/input_textfield.dart';
import '../../../../../core/presentation/widget/button/button.dart';
import '../../provider/register/register_provider.dart';
import '../../widget/auth_header.dart';

class RegisterPage extends ConsumerWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(registerNotifierProvider);
    final notifier = ref.read(registerNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header chung
              AuthHeader(
                title: "Đăng ký",
                onBack: () => notifier.onPressBack(context),
              ),

              16.verticalSpace,

              /// Subtitle theo đúng design
              Text(
                "Tạo tài khoản mới",
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.w600,
                  color: AppColors.bgDarkGreen,
                ),
              ),
              6.verticalSpace,
              Text(
                "Điền thông tin để bắt đầu sử dụng FinPal",
                style: TextStyle(fontSize: 14.sp, color: AppColors.typoBody),
              ),

              28.verticalSpace,

              /// 🔹 Full Name
              InputTextField(
                controller: state.usernameController,
                label: "Họ và tên",
                hintText: "Nguyễn Văn A",
                hasError: false,
              ),
              16.verticalSpace,

              /// 🔹 Email
              InputTextField(
                controller: state.emailController,
                label: "Email",
                hintText: "example@email.com",
                hasError: state.hasEmailError,
              ),
              16.verticalSpace,

              /// 🔹 Password
              InputTextField(
                controller: state.passwordController,
                label: "Mật khẩu",
                hintText: "********",
                isPassword: true,
                hasError: state.hasPasswordError,
              ),
              16.verticalSpace,

              /// 🔹 Confirm Password
              InputTextField(
                controller: state.confirmPasswordController,
                label: "Nhập lại mật khẩu",
                hintText: "********",
                isPassword: true,
                hasError: state.hasConfirmPasswordError,
              ),
              16.verticalSpace,

              /// 🔹 Bank Number
              InputTextField(
                controller: state.bankNumberController,
                label: "Số tài khoản ngân hàng",
                hintText: "Nhập số tài khoản (tùy chọn)",
                hasError: false,
              ),
              16.verticalSpace,

              /// 🔹 Bank Name
              InputTextField(
                controller: state.bankNameController,
                label: "Tên ngân hàng",
                hintText: "Nhập tên ngân hàng (tùy chọn)",
                hasError: false,
              ),

              20.verticalSpace,

              /// 🔹 Terms Box
              Container(
                padding: EdgeInsets.all(14.w),
                decoration: BoxDecoration(
                  color: const Color(0xffFEF8E7),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(color: Colors.amber.shade300),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.check_circle,
                      size: 20.sp,
                      color: AppColors.bgPrimary,
                    ),
                    8.horizontalSpace,
                    Expanded(
                      child: Text(
                        "Bằng cách đăng ký, bạn đồng ý với Điều khoản dịch vụ và Chính sách bảo mật của chúng tôi",
                        style: TextStyle(fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),
              ),

              28.verticalSpace,

              /// 🔹 Button custom
              Button(
                text: "Đăng ký",
                onPressed: state.isValid
                    ? () => notifier.onSignUp(context)
                    : null,
              ),

              30.verticalSpace,

              /// 🔹 Footer chung + Logo PNG (optional)
              AuthFooter(
                questionText: "Đã có tài khoản?",
                actionText: "Đăng nhập ngay",
                onActionPressed: () => notifier.onSignIn(context),
              ),

              20.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }
}
