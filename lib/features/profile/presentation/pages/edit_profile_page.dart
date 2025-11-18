import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_colors.dart';
import 'package:fridge_to_fork_ai/core/presentation/widget/header/header_with_back.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile_provider.dart';
import 'package:go_router/go_router.dart';

class EditProfilePage extends ConsumerStatefulWidget {
  const EditProfilePage({super.key});

  @override
  ConsumerState<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends ConsumerState<EditProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateControllers();
    });
  }

  @override
  void didUpdateWidget(covariant EditProfilePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _updateControllers();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _updateControllers() {
    final profileState = ref.read(profileNotifierProvider);
    _nameController.text = profileState.form.name ?? '';
    _emailController.text = profileState.form.email ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileNotifierProvider);
    final notifier = ref.read(profileNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: AppColors.bgSecondary,
      appBar: HeaderWithBack(
        title: 'Chỉnh sửa thông tin cá nhân',
        onBack: () => context.pop(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Thông tin cá nhân',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: AppColors.typoHeading,
                  ),
            ),
            SizedBox(height: 12.h),
            TextFormField(
              controller: _nameController,
              onChanged: notifier.updateName,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
              decoration: InputDecoration(
                labelText: 'Tên',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 16.h),
            TextFormField(
              controller: _emailController,
              onChanged: notifier.updateEmail,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(color: AppColors.typoHeading),
              decoration: InputDecoration(
                labelText: 'Email',
                labelStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(color: AppColors.typoBody),
                floatingLabelBehavior: FloatingLabelBehavior.always,
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
                  borderSide: BorderSide(color: AppColors.primaryGreen, width: 2.w),
                ),
                contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
              ),
            ),
            SizedBox(height: 24.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Bật thông báo',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: AppColors.typoHeading,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                Switch(
                  value: profileState.form.notificationEnabled ?? false,
                  onChanged: notifier.updateNotificationEnabled,
                  activeColor: AppColors.primaryGreen,
                ),
              ],
            ),
            SizedBox(height: 32.h),
            Text(
              'Lưu ý: Thay đổi Tên và Email hiện không được API hỗ trợ. Vui lòng liên hệ quản trị viên để cập nhật.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: AppColors.typoError),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 16.h),
            ElevatedButton(
              onPressed: profileState.isLoading ? null : () => notifier.saveProfile(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                elevation: 4,
                shadowColor: AppColors.primaryGreen.withOpacity(0.3),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text(
                'Lưu thay đổi',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.typoWhite,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
            SizedBox(height: 16.h),
            OutlinedButton(
              onPressed: () {
                context.pop();
              },
              style: OutlinedButton.styleFrom(
                side: BorderSide(color: AppColors.bgGray.withOpacity(0.5)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
                padding: EdgeInsets.symmetric(vertical: 16.h),
                minimumSize: Size(double.infinity, 50.h),
              ),
              child: Text(
                'Hủy',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: AppColors.typoBody,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
