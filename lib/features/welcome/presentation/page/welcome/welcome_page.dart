import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/welcome/presentation/provider/welcome/welcome_provider.dart';
import 'package:fridge_to_fork_ai/features/welcome/presentation/widgets/welcom_item.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/button/button.dart';
import '../../../../../core/presentation/widget/header/header_simple.dart';

class WelcomePage extends ConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(welcomeNotifierProvider.notifier);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const HeaderSimple(title: "Thiết lập ban đầu"),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 16.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🎉 Title
            Text(
              "Chào mừng!",
              style: TextStyle(
                fontSize: 28.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.bgDarkGreen,
              ),
            ),

            SizedBox(height: 6.h),

            /// Subtitle
            Text(
              "Hoàn thành các bước sau để bắt đầu sử dụng FinPal",
              style: TextStyle(fontSize: 14.sp, color: AppColors.typoBody),
            ),

            SizedBox(height: 28.h),

            /// ITEM 1 — Kết nối Sepay
            WelcomItem(
              icon: Icons.link_rounded,
              iconColor: AppColors.bgPrimary,
              miniTitle: "Kết nối sepay",
              description:
                  "Liên kết tài khoản Sepay để tự động ghi nhận giao dịch",
            ),

            SizedBox(height: 16.h),

            /// ITEM 2 — Bật thông báo
            WelcomItem(
              icon: Icons.notifications_active_outlined,
              iconColor: Colors.green,
              miniTitle: "Bật thông báo",
              description: "Nhận thông báo về giao dịch mới và gợi ý tài chính",
            ),

            SizedBox(height: 16.h),

            /// ITEM 3 — Xem giao dịch
            WelcomItem(
              icon: Icons.credit_card_outlined,
              iconColor: Colors.indigo,
              miniTitle: "Xem giao dịch",
              description: "Khám phá tính năng theo dõi và quản lý giao dịch",
            ),

            SizedBox(height: 32.h),

            /// BUTTON TIẾP TỤC
            Button(
              text: "Tiếp tục",
              onPressed: () => notifier.continueNext(context),
            ),

            SizedBox(height: 12.h),
          ],
        ),
      ),
    );
  }
}
