import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';

import 'package:fridge_to_fork_ai/features/budgets/data/api/budget_api.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/repositories/budget_repository_impl.dart';

import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/delete_budget.dart';

import 'budget_detail_notifier.dart';

/// -------------------------------------------------------
/// API
/// -------------------------------------------------------
final budgetDetailApiProvider = Provider<BudgetApi>(
  (ref) => ApiClient().create(BudgetApi.new),
);

/// -------------------------------------------------------
/// DATASOURCE
/// -------------------------------------------------------
final budgetDetailRemoteDataSourceProvider = Provider<BudgetRemoteDataSource>(
  (ref) => BudgetRemoteDataSource(ref.read(budgetDetailApiProvider)),
);

/// -------------------------------------------------------
/// REPOSITORY
/// -------------------------------------------------------
final budgetDetailRepositoryProvider = Provider<BudgetRepositoryImpl>(
  (ref) => BudgetRepositoryImpl(
    remoteDataSource: ref.read(budgetDetailRemoteDataSourceProvider),
  ),
);

/// -------------------------------------------------------
/// USE CASES
/// -------------------------------------------------------
final getBudgetByIdUseCaseProvider = Provider<GetBudgetByIdUseCase>(
  (ref) => GetBudgetByIdUseCase(ref.read(budgetDetailRepositoryProvider)),
);

final deleteBudgetUseCaseProvider = Provider<DeleteBudgetUseCase>(
  (ref) => DeleteBudgetUseCase(ref.read(budgetDetailRepositoryProvider)),
);

/// -------------------------------------------------------
/// NOTIFIER
/// -------------------------------------------------------
final budgetDetailNotifierProvider =
    StateNotifierProvider<BudgetDetailNotifier, BudgetDetailState>(
      (ref) => BudgetDetailNotifier(
        ref.read(getBudgetByIdUseCaseProvider),
        ref.read(deleteBudgetUseCaseProvider),
        ref,
      ),
    );
