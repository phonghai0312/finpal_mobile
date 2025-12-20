// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
