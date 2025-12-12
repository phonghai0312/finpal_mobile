import 'package:fridge_to_fork_ai/features/home/data/datasouces/home_remote_datasouces.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';

import '../../../../core/domain/entities/user.dart';
import '../../domain/repositories/home_repository.dart';

class HomeRepositoryImpl implements HomeRepository {
  final HomeRemoteDataSource remoteDataSource;

  HomeRepositoryImpl({required this.remoteDataSource});

  @override
  Future<StatsOverview> getStatsOverview() async {
    return await remoteDataSource.getStatsOverview();
  }

  @override
  Future<StatsByCategory> getStatsByCategory() async {
    return await remoteDataSource.getStatsByCategory();
  }

  @override
  Future<User> getUserInfo() async {
    return await remoteDataSource.getUserInfo();
  }
}
