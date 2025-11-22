import 'package:fridge_to_fork_ai/features/suggestions/data/datasources/insight_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/entities/insight.dart';
import 'package:fridge_to_fork_ai/features/suggestions/domain/repositories/insight_repository.dart';

class InsightRepositoryImpl implements InsightRepository {
  final InsightRemoteDataSource remoteDataSource;

  InsightRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Insight>> getInsights({String? type, int? page, int? pageSize}) async {
    return await remoteDataSource.getInsights(type: type, page: page, pageSize: pageSize);
  }

  @override
  Future<Insight> updateInsight(String id, bool read) async {
    return await remoteDataSource.updateInsight(id, read);
  }
}
