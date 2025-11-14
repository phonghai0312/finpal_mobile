import '../repositories/auth_repository.dart';

class Verify {
  final AuthRepository repository;
  Verify(this.repository);

  Future<void> call(String username, String code, String purpose) {
    return repository.verify(username, code, purpose);
  }
}
