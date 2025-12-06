import 'package:fridge_to_fork_ai/features/suggestions/data/datasources/insight_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/repositories/insight_repository.dart';

class InsightRepositoryImpl implements InsightRepository {
  final InsightRemoteDataSource remoteDataSource;

  InsightRepositoryImpl(this.remoteDataSource);

  @override
  Future<List<Insight>> getInsights({
    String? type,
    int? page,
    int? pageSize,
  }) async {
    final models = await remoteDataSource.getInsights(
      type: type,
      page: page,
      pageSize: pageSize,
    );

    // InsightModel extends Insight → cast sang List<Insight>
    return models.map((m) => m as Insight).toList();
  }
}
