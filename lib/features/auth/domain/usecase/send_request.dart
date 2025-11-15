import '../repositories/auth_repository.dart';

class SendRequest {
  final AuthRepository repository;
  SendRequest(this.repository);

  Future<void> call(String username) {
    return repository.sendRequest(username);
  }
}
