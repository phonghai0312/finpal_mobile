import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import '../../domain/repositories/profile_repository.dart';
import '../datasources/profile_remote_data_source.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileRemoteDataSource remoteDataSource;

  ProfileRepositoryImpl({required this.remoteDataSource});

  /// GET USER
  @override
  Future<User> getUser() async {
    final model = await remoteDataSource.getUser();

    return User(
      id: model.id,
      email: model.email,
      phone: model.phone,
      totalIncome: model.totalIncome,
      totalExpense: model.totalExpense,
      name: model.name,
      avatarUrl: model.avatarUrl,
      settings: model.settings, // settings là object model? để mình hỏi tiếp
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  /// UPDATE PROFILE
  @override
  Future<User> updateUser(String? name, String? phone) async {
    final model = await remoteDataSource.updateUser(name: name, phone: phone);

    return User(
      id: model.id,
      email: model.email,
      phone: model.phone,
      totalIncome: model.totalIncome,
      totalExpense: model.totalExpense,
      name: model.name,
      avatarUrl: model.avatarUrl,
      settings: model.settings,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }

  @override
  Future<void> logout() async {
    return await remoteDataSource.logout();
  }

  /// CHANGE PASSWORD
  // @override
  // Future<void> changePassword(
  //   String currentPassword,
  //   String newPassword,
  // ) {
  //   return remoteDataSource.changePassword(
  //     currentPassword: currentPassword,
  //     newPassword: newPassword,
  //   );
  // }
}
