import 'package:fridge_to_fork_ai/features/auth/data/datasouces/auth_remote_datasouces.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/entities/register.dart';
import 'package:fridge_to_fork_ai/features/auth/domain/repositories/auth_repository.dart';

import '../../domain/entities/login.dart';
import '../../domain/entities/refresh_token.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  AuthRepositoryImpl({required this.remoteDataSource});
  @override
  Future<Login> login(String email, String password) async {
    return remoteDataSource.login(email, password);
  }

  @override
  Future<Register> register(String email, String phone, String password) async {
    return remoteDataSource.register(email, phone, password);
  }

  @override
  Future<void> logout() async {
    return remoteDataSource.logout();
  }

  @override
  Future<RefreshToken> refreshToken() async {
    return remoteDataSource.refreshToken();
  }

  @override
  Future<void> verify(String username, String code, String purpose) {
    return remoteDataSource.verify(username, code, purpose);
  }

  @override
  Future<void> sendRequest(String username) {
    return remoteDataSource.sendRequest(username);
  }
}
