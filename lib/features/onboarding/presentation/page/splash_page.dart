// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../../core/presentation/theme/app_colors.dart';
import '../provider/splash/splash_notifier.dart';

class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(splashNotifierProvider.notifier).init(context, this);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(splashNotifierProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: FadeTransition(
          opacity: state.fadeAnim ?? kAlwaysCompleteAnimation,
          child: ScaleTransition(
            scale: state.scaleAnim ?? kAlwaysCompleteAnimation,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/image/logo_finpal.png',
                  height: 255.h,
                  width: 160.w,
                  fit: BoxFit.contain,
                ),
                SizedBox(height: 10.h),
                Text(
                  'FinPal',
                  style: GoogleFonts.poppins(
                    fontSize: 40.sp,
                    fontWeight: FontWeight.w700,
                    color: AppColors.bgDarkGreen,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
