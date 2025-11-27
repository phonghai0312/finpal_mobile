import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/repositories/insight_repository.dart';

class UpdateInsightUseCase {
  final InsightRepository repository;

  UpdateInsightUseCase(this.repository);

  Future<Insight> call(String id, bool read) async {
    return await repository.updateInsight(id, read);
  }
}
