import '../entities/refresh_token.dart';
import '../repositories/auth_repository.dart';

class RefreshTokenAccount {
  final AuthRepository repository;
  RefreshTokenAccount(this.repository);

  Future<RefreshToken> call(String refreshToken) {
    return repository.refreshToken(refreshToken);
  }
}
