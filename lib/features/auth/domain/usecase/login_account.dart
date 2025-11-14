import '../entities/login.dart';
import '../repositories/auth_repository.dart';

class LoginAccount {
  final AuthRepository repository;
  LoginAccount(this.repository);

  Future<Login> call(String username, String password, String origin) {
    return repository.login(username, password);
  }
}
