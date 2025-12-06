import '../entities/insight.dart';

abstract class InsightRepository {
  Future<List<Insight>> getInsights({String? type, int? page, int? pageSize});
}
