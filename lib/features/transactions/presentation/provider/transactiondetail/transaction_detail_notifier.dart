// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../domain/entities/transaction.dart';
import '../../../domain/usecase/delete_transaction.dart';
import '../../../domain/usecase/get_transaction_detail.dart';

class TransactionDetailState {
  final bool isEditing;
  final bool isLoading;
  final String? error;
  final Transaction? data;

  const TransactionDetailState({
    this.isEditing = false,
    this.isLoading = false,
    this.error,
    this.data,
  });

  TransactionDetailState copyWith({
    bool? isEditing,
    bool? isLoading,
    String? error,
    Transaction? data,
  }) {
    return TransactionDetailState(
      isEditing: isEditing ?? this.isEditing,
      isLoading: isLoading ?? this.isLoading,
      error: error,
      data: data ?? this.data,
    );
  }
}

class TransactionDetailNotifier extends StateNotifier<TransactionDetailState> {
  final GetTransactionDetail _getTransactionDetail;
  final DeleteTransaction _deleteTransaction;
  final Ref ref;

  bool _initialized = false;

  TransactionDetailNotifier(
    this._getTransactionDetail,
    this._deleteTransaction,
    this.ref,
  ) : super(const TransactionDetailState());

  // -----------------------------
  // LOAD DETAIL
  // -----------------------------
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    final selectedId = ref
        .read(transactionNotifierProvider.notifier)
        .selectedTransactionId;

    if (selectedId == null) {
      state = state.copyWith(error: "Không tìm thấy ID giao dịch");
      return;
    }

    try {
      state = state.copyWith(isLoading: true);
      final tx = await _getTransactionDetail(selectedId);
      state = state.copyWith(isLoading: false, data: tx);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  // -----------------------------
  // BACK
  // -----------------------------
  void onBack(BuildContext context) {
    context.go(AppRoutes.transactions);
  }

  // -----------------------------
  // XÓA GIAO DỊCH
  // -----------------------------
  Future<void> onDelete(BuildContext context, Transaction tx) async {
    try {
      await _deleteTransaction(tx.id);

      context.go(AppRoutes.transactions);

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Đã xoá giao dịch")));
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi xoá: $e"), backgroundColor: Colors.red),
      );
    }
  }

  // -----------------------------
  // EDIT MODE
  // -----------------------------
  void startEdit() {
    state = state.copyWith(isEditing: true);
  }

  void cancelEdit() {
    state = state.copyWith(isEditing: false);
  }
}
