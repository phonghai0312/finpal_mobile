import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';

import 'package:fridge_to_fork_ai/features/budgets/data/api/budget_api.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/repositories/budget_repository_impl.dart';

import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/create_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/update_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';

import 'budget_form_notifier.dart';

/// -------------------------------------------------------
/// API
/// -------------------------------------------------------
final budgetFormApiProvider = Provider<BudgetApi>(
  (ref) => ApiClient().create(BudgetApi.new),
);

/// -------------------------------------------------------
/// DATASOURCE
/// -------------------------------------------------------
final budgetFormRemoteDataSourceProvider = Provider<BudgetRemoteDataSource>(
  (ref) => BudgetRemoteDataSource(ref.read(budgetFormApiProvider)),
);

/// -------------------------------------------------------
/// REPOSITORY
/// -------------------------------------------------------
final budgetFormRepositoryProvider = Provider<BudgetRepositoryImpl>(
  (ref) => BudgetRepositoryImpl(
    remoteDataSource: ref.read(budgetFormRemoteDataSourceProvider),
  ),
);

/// -------------------------------------------------------
/// USE CASES
/// -------------------------------------------------------
final createBudgetUseCaseProvider = Provider<CreateBudgetUseCase>(
  (ref) => CreateBudgetUseCase(ref.read(budgetFormRepositoryProvider)),
);

final updateBudgetUseCaseProvider = Provider<UpdateBudgetUseCase>(
  (ref) => UpdateBudgetUseCase(ref.read(budgetFormRepositoryProvider)),
);

final getBudgetByIdForFormUseCaseProvider = Provider<GetBudgetByIdUseCase>(
  (ref) => GetBudgetByIdUseCase(ref.read(budgetFormRepositoryProvider)),
);

/// -------------------------------------------------------
/// NOTIFIER
/// -------------------------------------------------------
final budgetFormNotifierProvider =
    StateNotifierProvider<BudgetFormNotifier, BudgetFormState>(
      (ref) => BudgetFormNotifier(
        ref.read(createBudgetUseCaseProvider),
        ref.read(updateBudgetUseCaseProvider),
        ref.read(getBudgetByIdForFormUseCaseProvider),
        ref,
      ),
    );
