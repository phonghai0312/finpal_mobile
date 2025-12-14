// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';
import 'core/services/fcm_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Khởi tạo Firebase
  await Firebase.initializeApp();

  // Khởi tạo Easy Localization
  await EasyLocalization.ensureInitialized();

  // Khởi tạo FCM Service
  // Callbacks sẽ được set từ MyApp widget sau khi có ProviderScope
  await FcmService().initialize(
    onTokenRefresh: (String newToken) {
      // Token refresh callback sẽ được set trong MyApp
      debugPrint('FCM Token refreshed: $newToken');
    },
    onForegroundMessage: (RemoteMessage message) {
      // Xử lý foreground notification
      _handleForegroundNotification(message);
    },
  );

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('vi')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        startLocale: const Locale('en'),
        saveLocale: true,
        child: const MyApp(),
      ),
    ),
  );
}

/// Xử lý foreground notification
void _handleForegroundNotification(RemoteMessage message) {
  debugPrint('Foreground notification received: ${message.messageId}');
  debugPrint('Title: ${message.notification?.title}');
  debugPrint('Body: ${message.notification?.body}');
  debugPrint('Data: ${message.data}');

  // Có thể hiển thị dialog hoặc in-app notification ở đây
  // Ví dụ: sử dụng GetX, showDialog, hoặc custom notification widget
}
