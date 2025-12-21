// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/core/domain/entities/user.dart';
import 'package:fridge_to_fork_ai/features/budgets/domain/entities/budget.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget/budget_notifier.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget/budget_provider.dart';
import 'package:fridge_to_fork_ai/features/budgets/presentation/providers/budget_form/budget_form_provider.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_notifier.dart';
import 'package:fridge_to_fork_ai/features/profile/presentation/provider/profile/profile_provider.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_notifier.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';
import 'package:go_router/go_router.dart';

/// State
class HomeState {
  final User? user;

  final List<Budget> budgets;
  final List<Transaction> recentTransactions;

  final bool isLoading;
  final bool isRefreshing;
  final String? errorMessage;

  const HomeState({
    this.user,
    this.budgets = const [],
    this.recentTransactions = const [],
    this.isLoading = false,
    this.isRefreshing = false,
    this.errorMessage,
  });

  HomeState copyWith({
    User? user,
    List<Budget>? budgets,
    List<Transaction>? recentTransactions,
    bool? isLoading,
    bool? isRefreshing,
    String? errorMessage,
    bool clearUser = false,
  }) {
    return HomeState(
      user: clearUser ? null : (user ?? this.user),
      budgets: budgets ?? this.budgets,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      errorMessage: errorMessage,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final Ref ref;
  Timer? _debounce;

  HomeNotifier(this.ref) : super(const HomeState()) {
    _bindListeners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  /// --------------------------------
  /// INIT – gọi khi HomePage mở
  /// --------------------------------
  Future<void> init(BuildContext context) async {
    if (state.isLoading) return;

    state = state.copyWith(isLoading: true);

    await Future.wait([
      ref.read(profileNotifierProvider.notifier).init(context),
      ref.read(budgetNotifierProvider.notifier).init(context),
      ref.read(transactionNotifierProvider.notifier).init(context),
    ]);

    state = state.copyWith(isLoading: false);
  }

  /// --------------------------------
  /// PULL TO REFRESH
  /// --------------------------------
  Future<void> onRefresh(BuildContext context) async {
    state = state.copyWith(isRefreshing: true);

    await Future.wait([
      ref.read(profileNotifierProvider.notifier).fetchProfile(context),
      ref.read(budgetNotifierProvider.notifier).init(context),
      ref.read(transactionNotifierProvider.notifier).refresh(context),
    ]);

    state = state.copyWith(isRefreshing: false);
  }

  /// --------------------------------
  /// LISTENERS – SYNC DATA
  /// --------------------------------
  void _bindListeners() {
    /// USER → income / expense
    ref.listen<ProfileState>(profileNotifierProvider, (_, next) {
      final user = next.user;
      if (user == null) return;

      state = state.copyWith(user: user);
    });

    /// BUDGETS
    ref.listen<BudgetState>(budgetNotifierProvider, (_, next) {
      state = state.copyWith(budgets: next.budgets);
    });

    /// TRANSACTIONS → recent
    ref.listen<TransactionState>(transactionNotifierProvider, (_, next) {
      final recent = next.all.take(5).toList();
      state = state.copyWith(recentTransactions: recent);
    });
  }

  /// --------------------------------
  /// NAVIGATION (UI actions)

  void onPressViewAllTransactions(BuildContext context) {
    context.go(AppRoutes.transactions);
  }

  void onPressBudgets(BuildContext context) {
    context.go(AppRoutes.budgetDetail);
  }

  void onButtonCreateBudgets(BuildContext context) {
    ref.read(budgetFormNotifierProvider.notifier).enterCreateMode();
    context.go(AppRoutes.budgetForm);
  }
}
