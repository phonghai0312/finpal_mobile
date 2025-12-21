import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

class FcmService {
  FcmService._();

  static bool _initialized = false;
  static FirebaseMessaging? _messaging;

  /// Check if Firebase is initialized
  static bool _isFirebaseReady() {
    try {
      return Firebase.apps.isNotEmpty;
    } catch (e) {
      return false;
    }
  }

  /// Initialize FCM service
  /// MUST be called AFTER Firebase.initializeApp() in main.dart
  static Future<void> initialize() async {
    // Prevent multiple initializations
    if (_initialized) {
      return;
    }

    // ✅ CRITICAL: Verify Firebase is initialized
    if (!_isFirebaseReady()) {
      return;
    }

    try {
      _initialized = true;
      _messaging = FirebaseMessaging.instance;

      // ✅ STEP 1: Initialize local notifications for foreground display
      await LocalNotificationService.initialize();

      // ✅ STEP 2: Request notification permissions
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        return;
      }

      // ✅ STEP 3: Set up foreground message handler
      // This will display notifications when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        // Display local notification for foreground messages
        if (message.notification != null) {
          LocalNotificationService.show(
            title: message.notification!.title ?? 'Notification',
            body: message.notification!.body ?? '',
            payload: message.data,
          );
        }
      });

      // ✅ STEP 4: Handle notification tap when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {});

      // ✅ STEP 5: Handle notification tap when app was terminated
      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {}

      // ✅ STEP 6: Get and log FCM token
      try {
        await _messaging!.getToken();
        // ignore: empty_catches
      } catch (e) {}

      // ✅ STEP 7: Listen for token refresh
      _messaging!.onTokenRefresh.listen((String newToken) {});
    } catch (e) {
      _initialized = false;
      rethrow;
    }
  }

  /// Get FCM token
  /// Returns null if Firebase is not initialized or token retrieval fails
  static Future<String?> getToken() async {
    if (!_isFirebaseReady() || _messaging == null) {
      return null;
    }

    try {
      return await _messaging!.getToken();
    } catch (e) {
      return null;
    }
  }
}
