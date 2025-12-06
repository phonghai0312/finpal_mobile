import '../entities/insight.dart';
import '../repositories/insight_repository.dart';

class GetInsightsUseCase {
  final InsightRepository repository;

  GetInsightsUseCase(this.repository);

  Future<List<Insight>> call({String? type, int? page, int? pageSize}) {
    return repository.getInsights(type: type, page: page, pageSize: pageSize);
  }
}
