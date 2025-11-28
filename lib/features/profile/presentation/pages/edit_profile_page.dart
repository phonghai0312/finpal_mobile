// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
      appBar: AppBar(
        backgroundColor: AppColors.bgWhite,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColors.typoHeading),
          onPressed: () => notifier.goBack(context),
        ),
        title: Text(
          "Chỉnh sửa thông tin",
          style: Theme.of(
            context,
          ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Avatar + Tên + ID
            Center(
              child: Column(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 60.r,
                        backgroundImage: NetworkImage(
                          state.user?.avatarUrl ??
                              "https://www.gravatar.com/avatar/?d=mp",
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          padding: EdgeInsets.all(4.w),
                          decoration: BoxDecoration(
                            color: AppColors.primaryGreen,
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
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: AppColors.typoHeading,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    "ID: ${state.user?.id ?? "N/A"}",
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                  ),
                ],
              ),
            ),

            SizedBox(height: 32.h),

            Text(
              "Account Settings",
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: AppColors.typoHeading,
              ),
            ),
            SizedBox(height: 16.h),

            /// Name
            _inputField(
              context,
              controller: state.nameController,
              label: "Tên người dùng",
              keyboard: TextInputType.text,
            ),

            SizedBox(height: 16.h),

            /// Phone
            _inputField(
              context,
              controller: state.phoneController,
              label: "Số điện thoại",
              keyboard: TextInputType.phone,
            ),

            SizedBox(height: 16.h),

            /// Email (read-only)
            _inputField(
              context,
              controller: state.emailController,
              label: "Email",
              keyboard: TextInputType.emailAddress,
              readOnly: true,
            ),

            SizedBox(height: 32.h),

            /// SAVE BUTTON
            ElevatedButton(
              onPressed: state.isLoading ? null : () => notifier.save(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: state.isLoading
                  ? const CircularProgressIndicator(color: Colors.white)
                  : Text(
                      "Cập nhật",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.typoWhite,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

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
      style: TextStyle(color: AppColors.typoHeading),
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: AppColors.bgWhite,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
          borderSide: BorderSide(color: AppColors.primaryGreen),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      ),
    );
  }
}
