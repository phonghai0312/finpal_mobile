import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/home/domain/repositories/home_repository.dart';

class GetUserInfo {
  final HomeRepository repository;

  GetUserInfo(this.repository);

  Future<User> call() {
    return repository.getUserInfo();
  }
}
