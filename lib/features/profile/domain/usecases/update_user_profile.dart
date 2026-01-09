import 'package:finpal/core/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<User> call({
    String? name,
    String? phone,
    String? avatarUrl,
  }) async {
    return await repository.updateUser(
      name: name,
      phone: phone,
      avatarUrl: avatarUrl,
    );
  }
}
