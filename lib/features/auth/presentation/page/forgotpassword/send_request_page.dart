// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/presentation/widget/button/button.dart';
import '../../../../../core/presentation/widget/textinput/input_textfield.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../provider/forgotpassword/send_request_provider.dart';
import '../../widget/auth_header.dart';

class SendRequestPage extends ConsumerWidget {
  const SendRequestPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(sendRequestNotifierProvider);
    final notifier = ref.read(sendRequestNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Header theo design
              AuthHeader(title: "Khôi phục mật khẩu"),

              32.verticalSpace,

              /// Label
              Text(
                "Email",
                style: TextStyle(
                  fontSize: 14.sp,
                  color: AppColors.typoBody,
                  fontWeight: FontWeight.w500,
                ),
              ),
              8.verticalSpace,

              /// 🔹 Input Email
              InputTextField(
                controller: state.usernameController,
                label: "",
                hintText: "example@email.com",
                hasError: state.hasPhoneOrEmailError,
              ),

              40.verticalSpace,

              /// 🔹 Button Xác nhận
              Button(
                text: "Xác nhận",
                onPressed: state.isValid ? () {} : null,
                color: AppColors.bgDarkGreen,
              ),

              20.verticalSpace,

              GestureDetector(
                onTap: () => notifier.onPressSignIn(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      "Đăng nhập FinPal",
                      style: TextStyle(
                        fontSize: 18.sp,
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
              SizedBox(height: 40.h),

              /// 🔹 Ảnh PNG minh họa
              Center(
                child: Image.asset(
                  "assets/image/logo_finpal.png", // thay path của bạn
                  width: 255.w,
                  height: 350.w,
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
