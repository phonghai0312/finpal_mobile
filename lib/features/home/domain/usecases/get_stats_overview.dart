import 'package:fridge_to_fork_ai/features/home/domain/repositories/home_repository.dart';
import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_overview.dart';

class GetStatsOverviewUseCase {
  final HomeRepository repository;

  GetStatsOverviewUseCase(this.repository);

  Future<StatsOverview> call() {
    return repository.getStatsOverview();
  }
}
