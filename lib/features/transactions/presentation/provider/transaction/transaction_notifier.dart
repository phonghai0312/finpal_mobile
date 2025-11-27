// ignore_for_file: use_build_context_synchronously, unused_result

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/createtransaction/create_transaction_provider.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transactiondetail/transaction_detail_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/usecase/get_transactions.dart';

class TransactionState {
  final bool isLoading;
  final bool isRefreshing;
  final String currentFilter;
  final String? errorMessage;

  final List<Transaction> all;
  final List<Transaction> filtered;

  const TransactionState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.currentFilter = "all",
    this.errorMessage,
    this.all = const [],
    this.filtered = const [],
  });

  TransactionState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? currentFilter,
    String? errorMessage,
    List<Transaction>? all,
    List<Transaction>? filtered,
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentFilter: currentFilter ?? this.currentFilter,
      errorMessage: errorMessage,
      all: all ?? this.all,
      filtered: filtered ?? this.filtered,
    );
  }
}

class TransactionNotifier extends StateNotifier<TransactionState> {
  final GetTransactions _getTransactions;
  final Ref ref;
  Timer? _debounce;

  /// transaction được chọn để xem detail
  String? _selectedId;
  String? get selectedTransactionId => _selectedId;

  TransactionNotifier(this._getTransactions, this.ref)
    : super(const TransactionState());

  /// ============================================
  /// INIT PAGE
  /// ============================================
  Future<void> init(BuildContext context) async {
    state = state.copyWith(isLoading: true);

    try {
      final list = await _getTransactions();
      state = state.copyWith(
        isLoading: false,
        all: list,
        filtered: list, // mặc định filter = all
      );
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// ============================================
  /// FILTER: all | income | expense
  /// ============================================
  void filter(String type) {
    List<Transaction> result;

    if (type == "income") {
      result = state.all.where((t) => t.type == "income").toList();
    } else if (type == "expense") {
      result = state.all.where((t) => t.type == "expense").toList();
    } else {
      result = state.all;
    }

    state = state.copyWith(currentFilter: type, filtered: result);
  }

  /// ============================================
  /// REFRESH
  /// ============================================
  Future<void> refresh(BuildContext context) async {
    state = state.copyWith(isRefreshing: true);

    try {
      final list = await _getTransactions();

      state = state.copyWith(all: list, isRefreshing: false);

      /// giữ nguyên filter hiện tại
      filter(state.currentFilter);
    } catch (e) {
      state = state.copyWith(isRefreshing: false);
      _showError(context, e.toString());
    }
  }

  /// ============================================
  /// CLICK ITEM → DETAIL
  /// ============================================
  void onTransactionSelected(BuildContext context, Transaction tx) {
    _selectedId = tx.id;

    // Reset lại detail notifier
    ref.refresh(transactionDetailNotifierProvider);

    context.go(AppRoutes.transactionDetail);
  }

  /// ============================================
  /// ADD NEW
  /// ============================================
  void onPressAdd(BuildContext context) {
    ref.invalidate(createTransactionNotifierProvider);
    context.go(AppRoutes.createTransaction);
  }

  /// ============================================
  /// ERROR HANDLER
  /// ============================================
  void _showError(BuildContext context, String msg) {
    state = state.copyWith(errorMessage: msg);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  // void onPressEdit(BuildContext context) {
  //   context.go(AppRoutes.editTransaction);
  // }
  void onSearchChanged(String query) {
    _debounce?.cancel();

    _debounce = Timer(const Duration(milliseconds: 500), () {
      final cleanQuery = query.trim().toLowerCase();

      // Khôi phục danh sách nếu ô tìm kiếm rỗng
      if (cleanQuery.isEmpty) {
        state = state.copyWith(filtered: state.all);
        return;
      }

      final filtered = state.all.where((tx) {
        final amountStr = tx.amount.toString();
        return tx.merchant?.toLowerCase().contains(cleanQuery) == true ||
            tx.categoryName?.toLowerCase().contains(cleanQuery) == true ||
            tx.source.toLowerCase().contains(cleanQuery) ||
            amountStr.contains(cleanQuery);
      }).toList();

      state = state.copyWith(filtered: filtered);
    });
  }
}
