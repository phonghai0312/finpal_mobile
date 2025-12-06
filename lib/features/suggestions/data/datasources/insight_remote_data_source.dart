import 'package:fridge_to_fork_ai/features/suggestions/data/api/insight_api.dart';
import 'package:fridge_to_fork_ai/features/suggestions/data/models/insight_model.dart';

class InsightRemoteDataSource {
  final InsightApi api;

  InsightRemoteDataSource(this.api);

  Future<List<InsightModel>> getInsights({
    String? type,
    int? page,
    int? pageSize,
  }) async {
    final response = await api.getInsights(type, page, pageSize);
    return response.items;
  }
}
