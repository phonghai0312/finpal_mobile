import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/network/api_client.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/api/budget_api.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/datasources/budget_remote_data_source_impl.dart';
import 'package:fridge_to_fork_ai/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/repositories/budget_repository.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budgets.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/get_budget_by_id.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/create_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/update_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/usecases/delete_budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_notifier.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_detail_notifier.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_form_notifier.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';

/// API PROVIDER
final budgetApiProvider = Provider<BudgetApi>(
  (ref) => ApiClient().create(BudgetApi.new),
);

/// DATASOURCE
final budgetRemoteDataSourceProvider = Provider<BudgetRemoteDataSource>((ref) {
  return BudgetRemoteDataSourceImpl(
    api: ref.read(budgetApiProvider),
  );
});

/// REPOSITORY
final budgetRepositoryProvider = Provider<BudgetRepository>((ref) {
  return BudgetRepositoryImpl(
    remoteDataSource: ref.read(budgetRemoteDataSourceProvider),
  );
});

/// USECASE: Get Budgets
final getBudgetsUseCaseProvider = Provider<GetBudgetsUseCase>((ref) {
  return GetBudgetsUseCase(ref.read(budgetRepositoryProvider));
});

/// USECASE: Get Budget by ID
final getBudgetByIdUseCaseProvider = Provider<GetBudgetByIdUseCase>((ref) {
  return GetBudgetByIdUseCase(ref.read(budgetRepositoryProvider));
});

/// USECASE: Create Budget
final createBudgetUseCaseProvider = Provider<CreateBudgetUseCase>((ref) {
  return CreateBudgetUseCase(ref.read(budgetRepositoryProvider));
});

/// USECASE: Update Budget
final updateBudgetUseCaseProvider = Provider<UpdateBudgetUseCase>((ref) {
  return UpdateBudgetUseCase(ref.read(budgetRepositoryProvider));
});

/// USECASE: Delete Budget
final deleteBudgetUseCaseProvider = Provider<DeleteBudgetUseCase>((ref) {
  return DeleteBudgetUseCase(ref.read(budgetRepositoryProvider));
});

/// NOTIFIER
final budgetNotifierProvider =
    StateNotifierProvider<BudgetNotifier, BudgetState>((ref) {
      return BudgetNotifier(
        ref.read(getBudgetsUseCaseProvider),
        ref.read(getSpendAmountsUseCaseProvider),
      );
    });

/// SELECTED BUDGET ID PROVIDER
final selectedBudgetIdProvider = StateProvider<String?>((ref) => null);

/// NOTIFIER: Budget Detail
final budgetDetailNotifierProvider =
    StateNotifierProvider<BudgetDetailNotifier, BudgetDetailState>((ref) {
      return BudgetDetailNotifier(
        ref.read(getBudgetByIdUseCaseProvider),
        ref.read(deleteBudgetUseCaseProvider),
        ref,
      );
    });

/// NOTIFIER: Budget Form
final budgetFormNotifierProvider =
    StateNotifierProvider<BudgetFormNotifier, BudgetFormState>((ref) {
      return BudgetFormNotifier(
        ref.read(createBudgetUseCaseProvider),
        ref.read(updateBudgetUseCaseProvider),
        ref.read(getBudgetByIdUseCaseProvider),
      );
    });
