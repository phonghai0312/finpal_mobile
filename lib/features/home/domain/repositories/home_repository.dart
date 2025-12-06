import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart'
    show StatsOverview;
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';

import '../../../../core/domain/entities/user.dart';

abstract class HomeRepository {
  Future<StatsOverview> getStatsOverview();
  Future<StatsByCategory> getStatsByCategory();
  Future<User> getUserInfo();
}
