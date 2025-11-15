import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/onboarding/presentation/provider/onboarding/onboarding_provider.dart';
import 'package:fridge_to_fork_ai/features/onboarding/presentation/widgets/onboarding%20_item.dart';
import '../../../../core/presentation/theme/app_colors.dart';

class OnboardingPage extends ConsumerWidget {
  const OnboardingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(onboardingNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              /// khoảng cách đầu trang
              SizedBox(height: 28.h),

              /// IMAGE (cao hơn 1 chút để giống design)
              Image.asset(
                "assets/image/logo_finpal.png",
                width: 240.w,
                height: 260.w,
                fit: BoxFit.contain,
              ),

              /// khoảng cách giữa hình và chữ FinPal
              SizedBox(height: 30.h),

              /// FINPAL
              Text(
                "FinPal",
                style: TextStyle(
                  fontSize: 40.sp,
                  fontWeight: FontWeight.w700,
                  color: AppColors.bgDarkGreen,
                ),
              ),

              /// spacing giữa Title và Subtitle
              SizedBox(height: 8.h),

              /// SUBTITLE
              Text(
                "Quản lý tài chính cá nhân thông minh & an toàn",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: AppColors.bgPrimary),
              ),

              /// spacing lớn xuống các item
              SizedBox(height: 26.h),

              /// ITEM 1
              OnboardingItem(
                icon: Icons.auto_awesome,
                iconColor: Colors.amber,
                title: "Phân loại tự động với AI",
              ),

              SizedBox(height: 14.h),

              /// ITEM 2
              OnboardingItem(
                icon: Icons.trending_up_rounded,
                iconColor: AppColors.bgPrimary,
                title: "Thống kê chi tiêu thông minh",
              ),

              SizedBox(height: 14.h),

              /// ITEM 3
              OnboardingItem(
                icon: Icons.verified_user_rounded,
                iconColor: Colors.green,
                title: "Kết nối Sepay an toàn",
              ),

              /// spacing xuống Next
              SizedBox(height: 34.h),

              /// NEXT BUTTON
              Align(
                alignment: Alignment.centerRight,
                child: InkWell(
                  onTap: () => notifier.skip(context),
                  child: Text(
                    "Next >",
                    style: TextStyle(
                      fontSize: 20.sp,
                      fontWeight: FontWeight.w700,
                      color: AppColors.bgPrimary,
                    ),
                  ),
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
