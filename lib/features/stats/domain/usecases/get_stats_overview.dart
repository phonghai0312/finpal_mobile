/// Get Stats Overview UseCase
/// Dùng khi có backend
library;

import '../entities/stats_overview.dart';
import '../repositories/stats_repository.dart';

class GetStatsOverview {
  final StatsRepository repository;

  GetStatsOverview(this.repository);

  Future<StatsOverview> call({required int from, required int to}) {
    return repository.getStatsOverview(from: from, to: to);
  }
}
