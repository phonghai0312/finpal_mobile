// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/button/button.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/header/header_simple.dart';
import '../provider/profile/profile_provider.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(profileNotifierProvider.notifier).init(context);
    });
  }

  Widget _menuItem({
    required BuildContext context,
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16.w),
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
        decoration: BoxDecoration(
          color: AppColors.bgWhite,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: AppColors.bgGray.withOpacity(0.5)),
        ),
        child: Row(
          children: [
            Icon(icon, color: AppColors.bgDarkGreen, size: 22.sp),
            SizedBox(width: 12.w),
            Text(
              label,
              style: GoogleFonts.poppins(
                fontSize: 16.sp,
                color: AppColors.typoHeading,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              color: AppColors.typoBody,
              size: 18.sp,
            ),
          ],
        ),
      ),
    );
  }

  Widget _profileCard(BuildContext context, dynamic user) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: 16.w),
      padding: EdgeInsets.symmetric(vertical: 20.h),
      decoration: BoxDecoration(
        color: AppColors.bgDarkGreen,
        borderRadius: BorderRadius.circular(16.r),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 40.r,
            backgroundColor: AppColors.bgWhite,
            backgroundImage: NetworkImage(
              user?.avatarUrl ?? "https://www.gravatar.com/avatar/?d=mp",
            ),
          ),
          SizedBox(height: 12.h),
          Text(
            user?.name ?? "Người dùng",
            style: GoogleFonts.poppins(
              fontSize: 18.sp,
              fontWeight: FontWeight.w700,
              color: AppColors.typoWhite,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            "Email: ${user?.email ?? "N/A"}",
            style: GoogleFonts.poppins(
              fontSize: 14.sp,
              color: AppColors.typoWhite.withOpacity(0.9),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    if (state.isLoading && state.user == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: const HeaderSimple(title: "Cá nhân"),
      body: SingleChildScrollView(
        padding: EdgeInsets.only(bottom: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16.h),

            _profileCard(context, state.user),

            SizedBox(height: 24.h),

            _menuItem(
              context: context,
              icon: Icons.person_outline,
              label: "Chỉnh sửa thông tin cá nhân",
              onTap: () => notifier.goToEditProfile(context),
            ),
            SizedBox(height: 8.h),

            _menuItem(
              context: context,
              icon: Icons.settings_outlined,
              label: "Cài đặt",
              onTap: () => notifier.goToSettings(context),
            ),

            SizedBox(height: 28.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                "THÔNG TIN",
                style: GoogleFonts.poppins(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.typoBody,
                ),
              ),
            ),

            SizedBox(height: 12.h),

            _menuItem(
              context: context,
              icon: Icons.info_outline,
              label: "Về ứng dụng",
              onTap: () => notifier.goToAboutApp(context),
            ),

            SizedBox(height: 8.h),

            _menuItem(
              context: context,
              icon: Icons.help_outline,
              label: "Trợ giúp",
              onTap: () => notifier.goToHelpSupport(context),
            ),

            SizedBox(height: 8.h),

            _menuItem(
              context: context,
              icon: Icons.privacy_tip_outlined,
              label: "Chính sách bảo mật",
              onTap: () {},
            ),

            SizedBox(height: 24.h),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Button(
                text: "Đăng xuất",
                color: AppColors.bgError, // Nút rỗng để giống OutlinedButton
                textColor: AppColors.typoWhite, // Màu chữ đỏ
                onPressed: state.isLoading
                    ? null
                    : () => notifier.logout(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
