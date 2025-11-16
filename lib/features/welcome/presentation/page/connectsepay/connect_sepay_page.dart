// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fridge_to_fork_ai/features/welcome/presentation/provider/connectsepay/connect_sepay_provider.dart';
import 'package:fridge_to_fork_ai/features/welcome/presentation/widgets/welcom_item.dart';

import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../../../core/presentation/widget/button/button.dart';
import '../../../../../core/presentation/widget/header/header_with_back.dart';

class ConnectSepayPage extends ConsumerWidget {
  const ConnectSepayPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(connectSepayProvider);
    final notifier = ref.read(connectSepayProvider.notifier);

    return Scaffold(
      appBar: HeaderWithBack(
        title: "Kết nối Sepay",
        onBack: () => notifier.onPressBack(context),
      ),

      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            16.verticalSpace,

            /// WHY CONNECT
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: AppColors.bgDarkGreen,
                borderRadius: BorderRadius.circular(12.r),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Tại sao kết nối Sepay?",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  6.verticalSpace,
                  Text(
                    "Kết nối Sepay giúp tự động ghi nhận mọi giao dịch của bạn ngay khi thanh toán, không cần nhập thủ công.",
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),

            24.verticalSpace,

            /// Webhook title
            Text(
              "Webhook URL của bạn",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w600),
            ),

            10.verticalSpace,

            /// Webhook Box
            Container(
              padding: EdgeInsets.all(16.w),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    state.webhookUrl,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: AppColors.typoBody,
                    ),
                  ),
                  12.verticalSpace,
                  GestureDetector(
                    onTap: () => notifier.copyUrl(context),
                    child: Row(
                      children: [
                        const Icon(Icons.copy, size: 20, color: Colors.green),
                        8.horizontalSpace,
                        Text(
                          "Sao chép URL",
                          style: TextStyle(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w600,
                            color: AppColors.bgPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            30.verticalSpace,

            /// GUIDE TITLE
            Text(
              "Hướng dẫn kết nối",
              style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
            ),

            18.verticalSpace,

            /// STEP 1
            WelcomItem(
              icon: Icons.looks_one,
              iconColor: Colors.black,
              miniTitle: "Mở app/web Sepay",
              description:
                  "Truy cập myspepay.vn hoặc mở app Sepay trên điện thoại",
            ),
            16.verticalSpace,

            /// STEP 2
            WelcomItem(
              icon: Icons.looks_two,
              iconColor: Colors.black,
              miniTitle: "Kết nối tài khoản ngân hàng",
              description:
                  "Vào tab ngân hàng, chọn liên kết tài khoản và điền thông tin",
            ),
            16.verticalSpace,

            /// STEP 3
            WelcomItem(
              icon: Icons.looks_3,
              iconColor: Colors.black,
              miniTitle: "Tích hợp webhook",
              description:
                  "Vào mục Webhook, chọn thêm webhook và dán URL đã sao chép",
            ),

            40.verticalSpace,

            /// BUTTON MỞ SEPAY (nền trắng, chữ xanh)
            Button(
              text: "Mở Sepay",
              color: Colors.white,
              textColor: AppColors.bgDarkGreen,
              onPressed: notifier.openSepay,
            ),

            18.verticalSpace,

            /// BUTTON XÁC NHẬN
            Button(
              text: "Xác nhận",
              onPressed: () => notifier.confirm(context),
            ),

            30.verticalSpace,
          ],
        ),
      ),
    );
  }
}
