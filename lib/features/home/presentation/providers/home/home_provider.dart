import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/home/data/datasouces/home_remote_datasouces.dart'
    show HomeRemoteDataSource;
import 'package:fridge_to_fork_ai/features/home/data/repositories/home_repository_impl.dart'
    show HomeRepositoryImpl;
import 'package:fridge_to_fork_ai/features/home/domain/usecases/get_lastest_suggestion.dart'
    show GetLatestSuggestionUseCase;
import 'package:fridge_to_fork_ai/features/home/domain/usecases/get_user_info.dart'
    show GetUserInfo;

import '../../../domain/usecases/get_stats_by_category.dart';
import '../../../domain/usecases/get_stats_overview.dart';

import 'home_notifier.dart';

/// DATASOURCE
final homeRemoteDataSourceProvider = Provider<HomeRemoteDataSource>((ref) {
  return HomeRemoteDataSource();
});

/// REPOSITORY
final homeRepositoryProvider = Provider<HomeRepositoryImpl>((ref) {
  return HomeRepositoryImpl(
    remoteDataSource: ref.read(homeRemoteDataSourceProvider),
  );
});

/// USECASE: Stats overview
final getStatsOverviewProvider = Provider<GetStatsOverviewUseCase>((ref) {
  return GetStatsOverviewUseCase(ref.read(homeRepositoryProvider));
});

/// USECASE: Stats by category
final getStatsByCategoryProvider = Provider<GetStatsByCategoryUseCase>((ref) {
  return GetStatsByCategoryUseCase(ref.read(homeRepositoryProvider));
});

/// USECASE: Suggestion
final getLatestSuggestionProvider = Provider<GetLatestSuggestionUseCase>((ref) {
  return GetLatestSuggestionUseCase(ref.read(homeRepositoryProvider));
});

/// USECASE: User info
final getUserInfoProvider = Provider<GetUserInfo>((ref) {
  return GetUserInfo(ref.read(homeRepositoryProvider));
});

/// NOTIFIER
final homeNotifierProvider = StateNotifierProvider<HomeNotifier, HomeState>((
  ref,
) {
  return HomeNotifier(
    ref,
    ref.read(getStatsOverviewProvider),
    ref.read(getStatsByCategoryProvider),
    ref.read(getLatestSuggestionProvider),
    ref.read(getUserInfoProvider),
  );
});
