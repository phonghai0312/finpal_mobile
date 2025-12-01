// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/button/button.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/editprofie/edit_profile_provider.dart';

import '../../../../../core/presentation/theme/app_colors.dart';

class EditProfilePage extends ConsumerWidget {
  const EditProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(editProfileNotifierProvider);
    final notifier = ref.read(editProfileNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: "Chỉnh sửa thông tin",
        onBack: () => notifier.onBack(context),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ===========================
            /// 🔥 Avatar + Name + ID
            /// ===========================
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundColor: AppColors.bgGray.withOpacity(0.2),
                        backgroundImage: NetworkImage(
                          state.user?.avatarUrl ??
                              "https://www.gravatar.com/avatar/?d=mp",
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(6.w),
                          decoration: const BoxDecoration(
                            color: AppColors.bgDarkGreen,
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.camera_alt,
                            color: AppColors.typoWhite,
                            size: 20.sp,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.h),

                  Text(
                    state.user?.name ?? "Người dùng",
                    style: GoogleFonts.poppins(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.typoHeading,
                    ),
                  ),

                  SizedBox(height: 4.h),

                  Text(
                    "ID: ${state.user?.id ?? "N/A"}",
                    style: GoogleFonts.poppins(
                      fontSize: 14.sp,
                      color: AppColors.typoBody,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            /// ===========================
            /// 🔥 Section Title (Style mới)
            /// ===========================
            Text(
              "Cài đặt tài khoản",
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.bgDarkGreen,
              ),
            ),

            SizedBox(height: 20.h),

            /// ===========================
            /// 🔥 INPUT FIELDS
            /// ===========================
            _inputField(
              context,
              controller: notifier.nameController,
              label: "Tên người dùng",
              keyboard: TextInputType.text,
            ),

            SizedBox(height: 16.h),

            _inputField(
              context,
              controller: notifier.phoneController,
              label: "Số điện thoại",
              keyboard: TextInputType.phone,
            ),

            SizedBox(height: 16.h),

            _inputField(
              context,
              controller: notifier.emailController,
              label: "Email",
              keyboard: TextInputType.emailAddress,
              readOnly: true,
            ),

            SizedBox(height: 32.h),

            /// =============================
            /// 🔥 Save Button
            /// =============================
            Button(
              text: "Cập nhật",
              onPressed: state.isLoading
                  ? null
                  : () => notifier.onUpdate(context),
            ),

            if (state.isLoading)
              Padding(
                padding: EdgeInsets.only(top: 12.h),
                child: const Center(
                  child: CircularProgressIndicator(
                    color: AppColors.primaryGreen,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// =============================
  /// 🔥 INPUT FIELD STYLE MỚI
  /// =============================
  Widget _inputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required TextInputType keyboard,
    bool readOnly = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboard,
      readOnly: readOnly,
      style: GoogleFonts.poppins(fontSize: 15.sp, color: AppColors.typoHeading),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.poppins(
          fontSize: 14.sp,
          color: AppColors.typoBody,
        ),
        filled: true,
        fillColor: AppColors.bgWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.35)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14.r),
          borderSide: const BorderSide(color: AppColors.primaryGreen),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
