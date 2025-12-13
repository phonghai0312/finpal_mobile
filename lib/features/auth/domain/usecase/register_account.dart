import '../entities/register.dart';
import '../repositories/auth_repository.dart';

class RegisterAccount {
  final AuthRepository repository;
  RegisterAccount(this.repository);

  Future<Register> call(
    String email,
    String password, {
    String? bankNumber,
    String? bankName,
  }) {
    return repository.register(
      email,
      password,
      bankNumber: bankNumber,
      bankName: bankName,
    );
  }
}
