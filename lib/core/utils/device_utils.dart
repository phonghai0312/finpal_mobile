import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:io';

/// Utility class to get device information
class DeviceUtils {
  DeviceUtils._();

  static const String _deviceIdKey = 'device_id';
  static const _uuid = Uuid();

  /// Get or create a unique device ID
  /// This ID persists across app sessions
  static Future<String> getDeviceId() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? deviceId = prefs.getString(_deviceIdKey);

      if (deviceId == null || deviceId.isEmpty) {
        // Generate new UUID if not exists
        deviceId = _uuid.v4();
        await prefs.setString(_deviceIdKey, deviceId);
        print('[DeviceUtils] ✅ Generated new deviceId: $deviceId');
      } else {
        print('[DeviceUtils] ✅ Using existing deviceId: $deviceId');
      }

      return deviceId;
    } catch (e) {
      print('[DeviceUtils] ❌ Error getting deviceId: $e');
      // Fallback to generated UUID if SharedPreferences fails
      return _uuid.v4();
    }
  }

  /// Get platform name (android, ios, etc.)
  static String getPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'ios';
    } else {
      return 'unknown';
    }
  }
}


