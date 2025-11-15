import 'package:fridge_to_fork_ai/features/auth/domain/entities/login.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/refresh_token.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/register.dart';

abstract class AuthRepository {
  Future<Login> login(String email, String password);
  Future<Register> register(String email, String phone, String password);
  Future<void> logout();
  Future<RefreshToken> refreshToken(String refreshToken);
  Future<void> verify(String username, String code, String purpose);
  Future<void> sendRequest(String username);
}
