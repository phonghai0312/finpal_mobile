import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/repositories/insight_repository.dart';

class GetInsightByIdUseCase {
  final InsightRepository repository;

  GetInsightByIdUseCase(this.repository);

  Future<Insight> call(String id) async {
    return await repository.getInsightById(id);
  }
}
