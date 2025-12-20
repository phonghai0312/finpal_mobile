import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:fridge_to_fork_ai/core/network/api_client.dart';

import 'package:fridge_to_fork_ai/features/budgets/data/api/budget_api.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budgets.dart';

import 'package:fridge_to_fork_ai/features/transactions/data/api/transaction_api.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/repositories/transaction_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_spend_amounts.dart';

import 'budget_notifier.dart';

/// -------------------------------------------------------
/// API
/// -------------------------------------------------------
final budgetApiProvider = Provider<BudgetApi>(
  (ref) => ApiClient().create(BudgetApi.new),
);

final transactionApiProvider = Provider<TransactionApi>(
  (ref) => ApiClient().create(TransactionApi.new),
);

/// -------------------------------------------------------
/// DATASOURCES
/// -------------------------------------------------------
final budgetRemoteDataSourceProvider = Provider<BudgetRemoteDataSource>(
  (ref) => BudgetRemoteDataSource(ref.read(budgetApiProvider)),
);

final transactionRemoteDataSourceProvider =
    Provider<TransactionRemoteDataSource>(
      (ref) =>
          TransactionRemoteDataSource(api: ref.read(transactionApiProvider)),
    );

/// -------------------------------------------------------
/// REPOSITORIES
/// -------------------------------------------------------
final budgetRepositoryProvider = Provider<BudgetRepositoryImpl>(
  (ref) => BudgetRepositoryImpl(
    remoteDataSource: ref.read(budgetRemoteDataSourceProvider),
  ),
);

final transactionRepositoryProvider = Provider<TransactionRepositoryImpl>(
  (ref) =>
      TransactionRepositoryImpl(ref.read(transactionRemoteDataSourceProvider)),
);

/// -------------------------------------------------------
/// USE CASES
/// -------------------------------------------------------
final getBudgetsUseCaseProvider = Provider<GetBudgetsUseCase>(
  (ref) => GetBudgetsUseCase(ref.read(budgetRepositoryProvider)),
);

final getSpendAmountsUseCaseProvider = Provider<GetSpendAmounts>(
  (ref) => GetSpendAmounts(ref.read(transactionRepositoryProvider)),
);

/// -------------------------------------------------------
/// NOTIFIER
/// -------------------------------------------------------
final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, BudgetState>(
      (ref) => BudgetNotifier(
        ref.read(getBudgetsUseCaseProvider),
        ref.read(getSpendAmountsUseCaseProvider),
        ref,
      ),
    );
