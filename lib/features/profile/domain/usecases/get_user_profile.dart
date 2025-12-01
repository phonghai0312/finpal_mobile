import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<User> call() async {
    return await repository.getUser();
  }
}
