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
  final String? currentCategoryId;
  final String searchQuery;
  final String? errorMessage;

  final List<Transaction> all;
  final List<Transaction> filtered;

  const TransactionState({
    this.isLoading = false,
    this.isRefreshing = false,
    this.currentFilter = "all",
    this.currentCategoryId,
    this.searchQuery = "",
    this.errorMessage,
    this.all = const [],
    this.filtered = const [],
  });

  TransactionState copyWith({
    bool? isLoading,
    bool? isRefreshing,
    String? currentFilter,
    String? currentCategoryId,
    bool clearCategoryId = false,
    String? searchQuery,
    String? errorMessage,
    List<Transaction>? all,
    List<Transaction>? filtered,
  }) {
    return TransactionState(
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentFilter: currentFilter ?? this.currentFilter,
      currentCategoryId: clearCategoryId
          ? null
          : (currentCategoryId ?? this.currentCategoryId),
      searchQuery: searchQuery ?? this.searchQuery,
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
    _debounce?.cancel();
    state = state.copyWith(isLoading: true, searchQuery: "");

    try {
      final list = await _getTransactions();
      state = state.copyWith(isLoading: false, all: list);
      _applyFilters();
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  /// ============================================
  /// FILTER: all | income | expense
  /// ============================================
  void filter(String type) {
    state = state.copyWith(currentFilter: type);
    _applyFilters();
  }

  /// ============================================
  /// FILTER BY CATEGORY
  /// ============================================
  void setCategoryFilter(String? categoryId) {
    state = state.copyWith(
      currentCategoryId: categoryId,
      clearCategoryId: categoryId == null,
    );
    _applyFilters();
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
      _applyFilters();
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

    final cleanQuery = query.trim().toLowerCase();

    // Reset ngay khi ô tìm kiếm rỗng (tránh chờ debounce và tránh giữ filter cũ)
    if (cleanQuery.isEmpty) {
      state = state.copyWith(searchQuery: "");
      _applyFilters();
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      state = state.copyWith(searchQuery: cleanQuery);
      _applyFilters();
    });
  }

  void _applyFilters() {
    Iterable<Transaction> result = state.all;

    // type filter
    if (state.currentFilter == "income") {
      result = result.where((t) => t.type == "income");
    } else if (state.currentFilter == "expense") {
      result = result.where((t) => t.type == "expense");
    }

    // category filter
    if (state.currentCategoryId != null) {
      final categoryId = state.currentCategoryId!;
      result = result.where((t) => t.categoryId == categoryId);
    }

    // search filter
    final q = _normalizeForSearch(state.searchQuery);
    final rawQuery = state.searchQuery.trim();
    if (q.isNotEmpty) {
      result = result.where((tx) {
        final amountStr = tx.amount.toString();
        bool containsNormalized(String? value) {
          if (value == null || value.isEmpty) return false;
          return _normalizeForSearch(value).contains(q);
        }

        // Search theo "tên" (merchant/title) thay vì danh mục.
        return containsNormalized(tx.normalized.title) ||
            containsNormalized(tx.rawMessage) ||
            (rawQuery.isNotEmpty && amountStr.contains(rawQuery));
      });
    }

    state = state.copyWith(filtered: result.toList());
  }

  String _normalizeForSearch(String input) {
    final value = input.toLowerCase().trim().replaceAll(RegExp(r'\\s+'), ' ');
    if (value.isEmpty) return '';

    return value
        .replaceAll(RegExp(r'[àáạảãâầấậẩẫăằắặẳẵ]'), 'a')
        .replaceAll(RegExp(r'[èéẹẻẽêềếệểễ]'), 'e')
        .replaceAll(RegExp(r'[ìíịỉĩ]'), 'i')
        .replaceAll(RegExp(r'[òóọỏõôồốộổỗơờớợởỡ]'), 'o')
        .replaceAll(RegExp(r'[ùúụủũưừứựửữ]'), 'u')
        .replaceAll(RegExp(r'[ỳýỵỷỹ]'), 'y')
        .replaceAll(RegExp(r'[đ]'), 'd');
  }
}
