import 'package:fridge_to_fork_ai/features/auth/domain/entities/fcm_token.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/login.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/refresh_token.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/register.dart';

abstract class AuthRepository {
  Future<Login> login(String email, String password);
  Future<Register> register(
    String email,
    String password, {
    String? bankNumber,
    String? bankName,
  });
  Future<void> logout();
  Future<RefreshToken> refreshToken();
  Future<void> verify(String username, String code, String purpose);
  Future<void> sendRequest(String username);
  Future<FcmToken> registerFcmToken({
    required String userId,
    required String deviceId,
    required String fcmToken,
    required String platform,
  });
  Future<void> deactiveFcmToken({
    required String userId,
    required String deviceId,
  });
}
