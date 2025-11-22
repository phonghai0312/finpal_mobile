import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/repositories/insight_repository.dart';

class GetInsightsUseCase {
  final InsightRepository repository;

  GetInsightsUseCase(this.repository);

  Future<List<Insight>> call({String? type, int? page, int? pageSize}) async {
    return await repository.getInsights(type: type, page: page, pageSize: pageSize);
  }
}
