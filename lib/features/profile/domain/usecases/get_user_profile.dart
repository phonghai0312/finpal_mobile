import 'package:finpal/core/domain/entities/user.dart';
import 'package:finpal/features/profile/domain/repositories/profile_repository.dart';

class GetUserProfileUseCase {
  final ProfileRepository repository;

  GetUserProfileUseCase(this.repository);

  Future<User> call() async {
    return await repository.getUser();
  }
}
