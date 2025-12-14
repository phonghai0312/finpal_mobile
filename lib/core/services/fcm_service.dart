import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Top-level function để xử lý background messages
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Firebase đã được khởi tạo trong main() trước khi app chạy
  // Nhưng trong background isolate, cần đảm bảo Firebase đã được init
  debugPrint('Handling background message: ${message.messageId}');
}

class FcmService {
  static final FcmService _instance = FcmService._internal();
  factory FcmService() => _instance;
  FcmService._internal();

  FirebaseMessaging? _firebaseMessaging;
  FirebaseMessaging get _messaging {
    _firebaseMessaging ??= FirebaseMessaging.instance;
    return _firebaseMessaging!;
  }

  String? _currentToken;
  Function(String)? _onTokenRefresh;
  Function(RemoteMessage)? _onForegroundMessage;

  /// Set callback cho token refresh (có thể được set từ bên ngoài)
  void setTokenRefreshCallback(Function(String) callback) {
    _onTokenRefresh = callback;
  }

  /// Set callback cho foreground message (có thể được set từ bên ngoài)
  void setForegroundMessageCallback(Function(RemoteMessage) callback) {
    _onForegroundMessage = callback;
  }

  /// Khởi tạo FCM service
  Future<void> initialize({
    Function(String)? onTokenRefresh,
    Function(RemoteMessage)? onForegroundMessage,
  }) async {
    _onTokenRefresh = onTokenRefresh;
    _onForegroundMessage = onForegroundMessage;

    // Request permission
    NotificationSettings settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    debugPrint('User granted permission: ${settings.authorizationStatus}');

    // Đăng ký background message handler
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Lắng nghe foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      debugPrint('Got a message whilst in the foreground!');
      debugPrint('Message data: ${message.data}');

      if (message.notification != null) {
        debugPrint(
          'Message also contained a notification: ${message.notification?.title}',
        );
      }

      if (_onForegroundMessage != null) {
        _onForegroundMessage!(message);
      }
    });

    // Lắng nghe khi app mở từ terminated state
    RemoteMessage? initialMessage = await _messaging.getInitialMessage();
    if (initialMessage != null) {
      debugPrint(
        'App opened from terminated state: ${initialMessage.messageId}',
      );
      if (_onForegroundMessage != null) {
        _onForegroundMessage!(initialMessage);
      }
    }

    // Lắng nghe khi app mở từ background
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      debugPrint('App opened from background: ${message.messageId}');
      if (_onForegroundMessage != null) {
        _onForegroundMessage!(message);
      }
    });

    // Lắng nghe token refresh
    _messaging.onTokenRefresh.listen((String newToken) {
      debugPrint('FCM Token refreshed: $newToken');
      _currentToken = newToken;
      if (_onTokenRefresh != null) {
        _onTokenRefresh!(newToken);
      }
    });

    // Lấy token hiện tại
    await getToken();
  }

  /// Lấy FCM token
  Future<String?> getToken() async {
    try {
      _currentToken = await _messaging.getToken();
      debugPrint('FCM Token: $_currentToken');
      return _currentToken;
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }

  /// Lấy token hiện tại (đã cache)
  String? get currentToken => _currentToken;

  /// Lấy device ID (platform-specific)
  String getDeviceId() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    }
    return 'unknown';
  }

  /// Subscribe to topic
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _messaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _messaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Delete token (deactivate)
  Future<void> deleteToken() async {
    try {
      await _messaging.deleteToken();
      _currentToken = null;
      debugPrint('FCM Token deleted');
    } catch (e) {
      debugPrint('Error deleting FCM token: $e');
    }
  }
}
