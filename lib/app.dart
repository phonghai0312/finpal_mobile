import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:fridge_to_fork_ai/core/config/routing/app_router.dart';
import 'package:fridge_to_fork_ai/core/presentation/theme/app_theme.dart';
import 'package:fridge_to_fork_ai/core/services/fcm_service.dart';
import 'package:fridge_to_fork_ai/features/auth/presentation/provider/auth/auth_provider.dart';

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    // Setup FCM token refresh callback sau khi widget được khởi tạo
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FcmService().setTokenRefreshCallback((String newToken) {
        final authNotifier = ref.read(authProvider.notifier);
        authNotifier.handleFcmTokenRefresh(newToken);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp.router(
          title: 'Fin Pal',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          routerConfig: AppRouter.customerRouter,
          locale: context.locale,
          supportedLocales: context.supportedLocales,
          localizationsDelegates: context.localizationDelegates,
        );
      },
    );
  }
}
