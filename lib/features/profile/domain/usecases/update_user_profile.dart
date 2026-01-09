import 'package:finpal/core/domain/entities/user.dart';
import '../repositories/profile_repository.dart';

class UpdateUserProfileUseCase {
  final ProfileRepository repository;
  UpdateUserProfileUseCase(this.repository);

  Future<User> call({String? name, String? phone}) async {
    return await repository.updateUser(name, phone);
  }
}
