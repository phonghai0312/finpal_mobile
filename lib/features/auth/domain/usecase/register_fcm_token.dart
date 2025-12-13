import '../entities/fcm_token.dart';
import '../repositories/auth_repository.dart';

class RegisterFcmToken {
  final AuthRepository repository;
  RegisterFcmToken(this.repository);

  Future<FcmToken> call({
    required String userId,
    required String deviceId,
    required String fcmToken,
    required String platform,
  }) {
    return repository.registerFcmToken(
      userId: userId,
      deviceId: deviceId,
      fcmToken: fcmToken,
      platform: platform,
    );
  }
}
