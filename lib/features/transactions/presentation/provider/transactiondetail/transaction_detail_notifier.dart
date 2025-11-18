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
  final bool isLoading;
  final String? error;
  final Transaction? data;

  const TransactionDetailState({
    this.isLoading = false,
    this.error,
    this.data,
  });

  TransactionDetailState copyWith({
    bool? isLoading,
    String? error,
    Transaction? data,
  }) {
    return TransactionDetailState(
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

  /// cờ để đảm bảo init chỉ chạy 1 lần / 1 notifier instance
  bool _initialized = false;

  TransactionDetailNotifier(
      this._getTransactionDetail,
      this._deleteTransaction,
      this.ref,
      ) : super(const TransactionDetailState());

  /// gọi trong `addPostFrameCallback` ở page
  Future<void> init() async {
    if (_initialized) return;
    _initialized = true;

    // LẤY ID TỪ TransactionNotifier
    final transactionNotifier =
    ref.read(transactionNotifierProvider.notifier);
    final selectedId = transactionNotifier.selectedTransactionId;

    if (selectedId == null || selectedId.isEmpty) {
      state = state.copyWith(error: 'Không có giao dịch được chọn');
      return;
    }

    try {
      state = state.copyWith(isLoading: true, error: null);
      final tx = await _getTransactionDetail(selectedId);
      state = state.copyWith(isLoading: false, data: tx);
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  void onBack(BuildContext context) {
    context.go(AppRoutes.transactions);
  }

  /// TransactionDetailPage:
  /// `onPressed: () => notifier.onPressEdit(context, tx)`
  void onPressEdit(BuildContext context, Transaction tx) {
    context.go(
      AppRoutes.editTransaction,
      extra: tx,
    );
  }

  Future<void> onDelete(BuildContext context, Transaction tx) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      await _deleteTransaction(tx.id);

      // quay về list + show snackbar
      context.go(AppRoutes.transactions);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã xoá giao dịch'),
        ),
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Lỗi xoá: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
