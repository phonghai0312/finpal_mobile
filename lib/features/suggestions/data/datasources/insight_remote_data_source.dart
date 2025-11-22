import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';

abstract class InsightRemoteDataSource {
  Future<List<Insight>> getInsights({String? type, int? page, int? pageSize});
  Future<Insight> updateInsight(String id, bool read);
}
