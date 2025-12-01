import '../entities/login.dart';
import '../repositories/auth_repository.dart';

class LoginAccount {
  final AuthRepository repository;
  LoginAccount(this.repository);

  Future<Login> call(String email, String password) {
    return repository.login(email, password);
  }
}
