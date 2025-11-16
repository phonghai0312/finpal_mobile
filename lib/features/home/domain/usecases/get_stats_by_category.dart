import 'package:fridge_to_fork_ai/features/stats/domain/entities/stats_by_category.dart'
    show StatsByCategory;
import '../repositories/home_repository.dart';

class GetStatsByCategoryUseCase {
  final HomeRepository repository;
  GetStatsByCategoryUseCase(this.repository);

  Future<StatsByCategory> call() {
    return repository.getStatsByCategory();
  }
}
