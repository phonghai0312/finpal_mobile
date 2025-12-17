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
      print('[FCM] ❌ Error checking Firebase status: $e');
      return false;
    }
  }

  /// Initialize FCM service
  /// MUST be called AFTER Firebase.initializeApp() in main.dart
  static Future<void> initialize() async {
    // Prevent multiple initializations
    if (_initialized) {
      print('[FCM] ⚠️ Already initialized, skipping...');
      return;
    }

    // ✅ CRITICAL: Verify Firebase is initialized
    if (!_isFirebaseReady()) {
      print('[FCM] ❌ Firebase not initialized! Cannot initialize FCM.');
      print('[FCM] 💡 Ensure Firebase.initializeApp() is called BEFORE runApp()');
      return;
    }

    try {
      _initialized = true;
      _messaging = FirebaseMessaging.instance;

      print('[FCM] 🔔 Initializing FCM service...');

      // ✅ STEP 1: Initialize local notifications for foreground display
      await LocalNotificationService.initialize();
      print('[FCM] ✅ Local notifications initialized');

      // ✅ STEP 2: Request notification permissions
      final settings = await _messaging!.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      print('[FCM] 📱 Permission status: ${settings.authorizationStatus}');

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        print('[FCM] ⚠️ Notification permission denied');
        return;
      }

      // ✅ STEP 3: Set up foreground message handler
      // This will display notifications when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('[FCM] 📨 Foreground message received:');
        print('[FCM]   - Title: ${message.notification?.title}');
        print('[FCM]   - Body: ${message.notification?.body}');
        print('[FCM]   - Data: ${message.data}');

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
      FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
        print('[FCM] 📬 App opened from background notification:');
        print('[FCM]   - Title: ${message.notification?.title}');
        print('[FCM]   - Body: ${message.notification?.body}');
        print('[FCM]   - Data: ${message.data}');
        // TODO: Navigate to appropriate screen based on message.data
      });

      // ✅ STEP 5: Handle notification tap when app was terminated
      final initialMessage = await _messaging!.getInitialMessage();
      if (initialMessage != null) {
        print('[FCM] 📬 App opened from terminated state:');
        print('[FCM]   - Title: ${initialMessage.notification?.title}');
        print('[FCM]   - Body: ${initialMessage.notification?.body}');
        print('[FCM]   - Data: ${initialMessage.data}');
        // TODO: Navigate to appropriate screen based on message.data
      }

      // ✅ STEP 6: Get and log FCM token
      try {
        final token = await _messaging!.getToken();
        print('[FCM] 🔑 FCM Token: ${token?.substring(0, token.length > 50 ? 50 : token.length)}...');
      } catch (e) {
        print('[FCM] ⚠️ Failed to get FCM token: $e');
      }

      // ✅ STEP 7: Listen for token refresh
      _messaging!.onTokenRefresh.listen((String newToken) {
        print('[FCM] 🔄 Token refreshed: ${newToken.substring(0, newToken.length > 50 ? 50 : newToken.length)}...');
        // TODO: Send updated token to backend
      });

      print('[FCM] ✅ FCM service initialized successfully');
    } catch (e, stackTrace) {
      print('[FCM] ❌ Error initializing FCM: $e');
      print('[FCM] Stack trace: $stackTrace');
      _initialized = false;
      rethrow;
    }
  }

  /// Get FCM token
  /// Returns null if Firebase is not initialized or token retrieval fails
  static Future<String?> getToken() async {
    if (!_isFirebaseReady() || _messaging == null) {
      print('[FCM] ⚠️ Cannot get token: Firebase not initialized');
      return null;
    }

    try {
      return await _messaging!.getToken();
    } catch (e) {
      print('[FCM] ❌ Error getting token: $e');
      return null;
    }
  }
}
