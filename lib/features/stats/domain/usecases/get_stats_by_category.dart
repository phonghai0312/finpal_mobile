library;

import '../entities/stats_by_category.dart';
import '../repositories/stats_repositories.dart';

class GetStatsByCategory {
  final StatsRepository repository;

  GetStatsByCategory(this.repository);

  Future<StatsByCategory> call({required int from, required int to}) {
    return repository.getStatsByCategory(from: from, to: to);
  }
}
