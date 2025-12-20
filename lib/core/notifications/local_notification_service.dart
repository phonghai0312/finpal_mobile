import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/material.dart';

class LocalNotificationService {
  LocalNotificationService._();

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  // Channel ID must match AndroidManifest.xml meta-data
  static const String _channelId = 'high_importance_channel';
  static const String _channelName = 'High Importance Notifications';
  static const String _channelDescription = 'Thông báo quan trọng';

  /// Initialize local notifications
  /// MUST be called before showing any notifications
  static Future<void> initialize() async {
    if (_initialized) {
      debugPrint('[LOCAL NOTI] ⚠️ Already initialized');
      return;
    }

    try {
      // Android initialization settings
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher', // Use app icon
      );

      // iOS initialization settings
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const settings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      // Initialize plugin
      final initialized = await _plugin.initialize(
        settings,
        onDidReceiveNotificationResponse: (NotificationResponse response) {
          debugPrint('[LOCAL NOTI] 📬 Notification tapped:');
          debugPrint('[LOCAL NOTI]   - ID: ${response.id}');
          debugPrint('[LOCAL NOTI]   - Payload: ${response.payload}');
        },
      );

      if (initialized == null) {
        debugPrint('[LOCAL NOTI] ❌ Initialization failed');
        return;
      }

      // Create Android notification channel (required for Android 8.0+)
      await _createNotificationChannel();

      _initialized = true;
      debugPrint('[LOCAL NOTI] ✅ Initialized successfully');
    } catch (e, stackTrace) {
      debugPrint('[LOCAL NOTI] ❌ Error initializing: $e');
      debugPrint('[LOCAL NOTI] Stack trace: $stackTrace');
      rethrow;
    }
  }

  /// Create Android notification channel
  /// Required for Android 8.0 (API level 26) and above
  static Future<void> _createNotificationChannel() async {
    const androidChannel = AndroidNotificationChannel(
      _channelId,
      _channelName,
      description: _channelDescription,
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
      showBadge: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(androidChannel);

    debugPrint('[LOCAL NOTI] ✅ Notification channel created: $_channelId');
  }

  /// Show a local notification
  /// Use this for foreground FCM messages
  static Future<void> show({
    required String title,
    required String body,
    Map<String, dynamic>? payload,
  }) async {
    if (!_initialized) {
      debugPrint('[LOCAL NOTI] ⚠️ Not initialized. Call initialize() first.');
      return;
    }

    try {
      const androidDetails = AndroidNotificationDetails(
        _channelId,
        _channelName,
        channelDescription: _channelDescription,
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

      // Use timestamp as notification ID to ensure uniqueness
      final notificationId = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await _plugin.show(
        notificationId,
        title,
        body,
        details,
        payload: payload?.toString(),
      );

      debugPrint('[LOCAL NOTI] ✅ Notification shown: $title');
    } catch (e, stackTrace) {
      debugPrint('[LOCAL NOTI] ❌ Error showing notification: $e');
      debugPrint('[LOCAL NOTI] Stack trace: $stackTrace');
    }
  }
}
