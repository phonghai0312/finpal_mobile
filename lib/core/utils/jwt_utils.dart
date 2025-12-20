import 'package:jwt_decoder/jwt_decoder.dart';

/// Utility class to decode JWT tokens
class JwtUtils {
  JwtUtils._();

  /// Get user ID from JWT token
  /// Returns null if token is invalid or doesn't contain 'id' or 'userId'
  static String? getUserIdFromToken(String? token) {
    if (token == null || token.isEmpty) {
      return null;
    }

    try {
      final decodedToken = JwtDecoder.decode(token);
      
      // Try common JWT payload fields for user ID
      if (decodedToken.containsKey('id')) {
        return decodedToken['id']?.toString();
      }
      if (decodedToken.containsKey('userId')) {
        return decodedToken['userId']?.toString();
      }
      if (decodedToken.containsKey('user_id')) {
        return decodedToken['user_id']?.toString();
      }
      if (decodedToken.containsKey('sub')) {
        return decodedToken['sub']?.toString();
      }

      print('[JwtUtils] ⚠️ Token không chứa userId field');
      return null;
    } catch (e) {
      print('[JwtUtils] ❌ Lỗi decode token: $e');
      return null;
    }
  }

  /// Check if token is expired
  static bool isTokenExpired(String? token) {
    if (token == null || token.isEmpty) {
      return true;
    }

    try {
      return JwtDecoder.isExpired(token);
    } catch (e) {
      print('[JwtUtils] ❌ Lỗi kiểm tra token expiry: $e');
      return true;
    }
  }
}


