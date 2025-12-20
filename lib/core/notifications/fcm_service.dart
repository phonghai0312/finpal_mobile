import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'local_notification_service.dart';

/// Callback function type for token refresh
/// Parameters: (newToken: String, userId: String, deviceId: String)
typedef TokenRefreshCallback = Future<void> Function(
  String newToken,
  String userId,
  String deviceId,
);

class FcmService {
  FcmService._();

  static bool _initialized = false;
  static FirebaseMessaging? _messaging;
  static TokenRefreshCallback? _tokenRefreshCallback;

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
      print('[FCM] 📱 Alert: ${settings.alert}');
      print('[FCM] 📱 Badge: ${settings.badge}');
      print('[FCM] 📱 Sound: ${settings.sound}');

      if (settings.authorizationStatus != AuthorizationStatus.authorized &&
          settings.authorizationStatus != AuthorizationStatus.provisional) {
        print('[FCM] ⚠️ Notification permission denied - Status: ${settings.authorizationStatus}');
        print('[FCM] 💡 Hãy kiểm tra Settings > Apps > Notifications');
        // KHÔNG return ở đây - vẫn tiếp tục để có thể nhận data-only messages
      }

      // ✅ STEP 3: Set up foreground message handler
      // This will display notifications when app is in foreground
      FirebaseMessaging.onMessage.listen((RemoteMessage message) {
        print('[FCM] 📨 Foreground message received:');
        print('[FCM]   - Message ID: ${message.messageId}');
        print('[FCM]   - From: ${message.from}');
        print('[FCM]   - Title: ${message.notification?.title}');
        print('[FCM]   - Body: ${message.notification?.body}');
        print('[FCM]   - Data: ${message.data}');
        print('[FCM]   - Has notification payload: ${message.notification != null}');
        print('[FCM]   - Has data payload: ${message.data.isNotEmpty}');

        // Display local notification for foreground messages
        // Hiển thị cả khi có notification payload hoặc chỉ có data payload
        if (message.notification != null) {
          LocalNotificationService.show(
            title: message.notification!.title ?? 'Notification',
            body: message.notification!.body ?? '',
            payload: message.data,
          );
        } else if (message.data.isNotEmpty) {
          // Nếu chỉ có data payload, vẫn hiển thị notification
          LocalNotificationService.show(
            title: message.data['title'] ?? 'Notification',
            body: message.data['body'] ?? message.data.toString(),
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
      _messaging!.onTokenRefresh.listen((String newToken) async {
        print('[FCM] 🔄 Token refreshed: ${newToken.substring(0, newToken.length > 50 ? 50 : newToken.length)}...');
        
        // Gửi token refresh lên backend nếu có callback
        if (_tokenRefreshCallback != null) {
          try {
            await _tokenRefreshCallback!(newToken, '', '');
            print('[FCM] ✅ Token refresh đã được gửi lên backend');
          } catch (e, stackTrace) {
            print('[FCM] ❌ Lỗi khi gửi token refresh lên backend: $e');
            print('[FCM] Stack trace: $stackTrace');
          }
        } else {
          print('[FCM] ⚠️ Token refresh callback chưa được set, không thể gửi lên backend');
        }
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

  /// Set callback for token refresh
  /// This callback will be called when FCM token is refreshed
  /// Call this after user login to enable automatic token refresh updates
  static void setTokenRefreshCallback(TokenRefreshCallback? callback) {
    _tokenRefreshCallback = callback;
    if (callback != null) {
      print('[FCM] ✅ Token refresh callback đã được set');
    } else {
      print('[FCM] ⚠️ Token refresh callback đã được xóa');
    }
  }
}
