import '../repositories/auth_repository.dart';

class DeactiveFcmToken {
  final AuthRepository repository;
  DeactiveFcmToken(this.repository);

  Future<void> call({
    required String userId,
    required String deviceId,
  }) {
    return repository.deactiveFcmToken(
      userId: userId,
      deviceId: deviceId,
    );
  }
}


