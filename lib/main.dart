// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app.dart';

// Background message handler (phải là top-level function)
// LƯU Ý: Handler này chạy trong isolate riêng, cần init Firebase riêng
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Kiểm tra Firebase đã init chưa (trong isolate này)
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
  
  print('[FCM Background] 📨 Nhận notification khi app ở background/killed:');
  print('[FCM Background]   - Message ID: ${message.messageId}');
  print('[FCM Background]   - From: ${message.from}');
  print('[FCM Background]   - Title: ${message.notification?.title}');
  print('[FCM Background]   - Body: ${message.notification?.body}');
  print('[FCM Background]   - Data: ${message.data}');
  print('[FCM Background]   - Has notification payload: ${message.notification != null}');
  print('[FCM Background]   - Has data payload: ${message.data.isNotEmpty}');
  
  // ✅ CRITICAL: Hiển thị notification khi app ở background/killed
  // Import LocalNotificationService trong background handler
  try {
    // Initialize local notifications trong background isolate
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings();
    const settings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );
    
    final plugin = FlutterLocalNotificationsPlugin();
    await plugin.initialize(settings);
    
    // Tạo notification channel nếu chưa có
    await plugin
        .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
            'high_importance_channel',
            'High Importance Notifications',
            description: 'Thông báo quan trọng',
            importance: Importance.high,
            playSound: true,
            enableVibration: true,
          ),
        );
    
    // Hiển thị notification - cả khi có notification payload hoặc chỉ có data payload
    if (message.notification != null || message.data.isNotEmpty) {
      const androidDetails = AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'Thông báo quan trọng',
        importance: Importance.high,
        priority: Priority.high,
        playSound: true,
        enableVibration: true,
        showWhen: true,
        icon: '@mipmap/ic_launcher',
      );
      
      const iosDetails = DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      );
      
      const details = NotificationDetails(
        android: androidDetails,
        iOS: iosDetails,
      );
      
      final title = message.notification?.title ?? message.data['title'] ?? 'Notification';
      final body = message.notification?.body ?? message.data['body'] ?? message.data.toString();
      
      await plugin.show(
        DateTime.now().millisecondsSinceEpoch ~/ 1000,
        title,
        body,
        details,
      );
      
      print('[FCM Background] ✅ Notification đã được hiển thị');
    }
  } catch (e, stackTrace) {
    print('[FCM Background] ❌ Lỗi khi hiển thị notification: $e');
    print('[FCM Background] Stack trace: $stackTrace');
  }

}

Future<void> main() async {
  // ✅ STEP 1: Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ STEP 2: Initialize localization (fast, non-blocking)
  await EasyLocalization.ensureInitialized();

  // ✅ STEP 3: Initialize Firebase BEFORE any FCM logic
  // This MUST happen before runApp() to ensure Firebase is ready
  try {
    // Check if Firebase is already initialized (e.g., hot reload)
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    } else {}
  } catch (e) {
    // Continue anyway - app will work but FCM won't function
  }

  // ✅ STEP 4: Register background message handler
  // Must be registered BEFORE runApp() and only once
  try {
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    // ignore: empty_catches
  } catch (e) {}

  // ✅ STEP 5: Run the app
  // Firebase is now guaranteed to be initialized
  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('vi')],
        path: 'assets/lang',
        fallbackLocale: const Locale('en'),
        child: const MyApp(),
      ),
    ),
  );
}
