import '../entities/register.dart';
import '../repositories/auth_repository.dart';

class RegisterAccount {
  final AuthRepository repository;
  RegisterAccount(this.repository);

  Future<Register> call(String email, String phone, String password) {
    return repository.register(email, phone, password);
  }
}
