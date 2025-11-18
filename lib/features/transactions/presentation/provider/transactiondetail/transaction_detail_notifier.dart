// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';
import 'package:go_router/go_router.dart';

import '../../../../../core/config/routing/app_routes.dart';
import '../../../../../core/presentation/theme/app_colors.dart';
import '../../../domain/entities/transaction.dart';
import '../../../domain/usecase/get_transaction_detail.dart';

/// ===============================
/// STATE
/// ===============================
class TransactionDetailState {
  final Transaction? detail;
  final bool isLoading;
  final bool isRefreshing;
  final String? currentId;
  final String? errorMessage;

  const TransactionDetailState({
    this.detail,
    this.isLoading = false,
    this.isRefreshing = false,
    this.currentId,
    this.errorMessage,
  });

  TransactionDetailState copyWith({
    Transaction? detail,
    bool? isLoading,
    bool? isRefreshing,
    String? currentId,
    String? errorMessage,
  }) {
    return TransactionDetailState(
      detail: detail ?? this.detail,
      isLoading: isLoading ?? this.isLoading,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      currentId: currentId ?? this.currentId,
      errorMessage: errorMessage,
    );
  }
}

/// ===============================
/// NOTIFIER
/// ===============================
class TransactionDetailNotifier extends StateNotifier<TransactionDetailState> {
  final GetTransactionDetail _getTransactionDetail;
  final Ref ref;

  TransactionDetailNotifier(this._getTransactionDetail, this.ref)
    : super(const TransactionDetailState());

  /// ===============================
  /// INIT SCREEN
  /// ===============================
  Future<void> init(BuildContext context) async {
    final listNotifier = ref.read(transactionNotifierProvider.notifier);
    final id = listNotifier.selectedTransactionId;
    if (id == null) return;

    await load(context, id);
  }

  /// ===============================
  /// LOAD DETAIL
  /// ===============================
  Future<void> load(BuildContext context, String id) async {
    if (state.currentId != id) {
      state = state.copyWith(
        currentId: id,
        detail: null,
        isLoading: true,
        isRefreshing: false,
        errorMessage: null,
      );
    }

    try {
      final detail = await _getTransactionDetail(id);

      state = state.copyWith(
        detail: detail,
        isLoading: false,
        isRefreshing: false,
      );
    } catch (e) {
      _handleFailure(context, e.toString());
    }
  }

  /// ===============================
  /// INIT LOAD (Avoid reload)
  /// ===============================
  Future<void> initLoad(BuildContext context) async {
    final listNotifier = ref.read(transactionNotifierProvider.notifier);
    final id = listNotifier.selectedTransactionId;

    if (id == null) {
      state = const TransactionDetailState(detail: null);
      return;
    }

    // Đã load data rồi → không cần fetch lại
    if (state.currentId == id && state.detail != null) return;

    await load(context, id);
  }

  /// ===============================
  /// REFRESH
  /// ===============================
  Future<void> refresh(BuildContext context) async {
    if (state.currentId == null) return;

    state = state.copyWith(isRefreshing: true);

    try {
      final detail = await _getTransactionDetail(state.currentId!);
      state = state.copyWith(detail: detail, isRefreshing: false);
    } catch (e) {
      _handleFailure(context, e.toString());
    }
  }

  /// ===============================
  /// HANDLE ERROR
  /// ===============================
  void _handleFailure(BuildContext context, String message) {
    state = state.copyWith(
      isLoading: false,
      isRefreshing: false,
      errorMessage: message,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// ===============================
  /// BACK
  /// ===============================
  void onBack(BuildContext context) {
    context.go(AppRoutes.transactions);
  }

  /// ===============================
  /// STATUS CATEGORIES UI MAPPING
  /// ===============================
  Map<String, dynamic> getStatusDesign(String type) {
    switch (type.toLowerCase()) {
      case 'income':
        return {'text': 'Income', 'color': AppColors.bgSuccess};
      case 'expense':
        return {'text': 'Expense', 'color': AppColors.bgError.withOpacity(0.6)};
      case 'transfer':
        return {'text': 'Transfer', 'color': AppColors.bgWarning};
      default:
        return {'text': 'Unknown', 'color': const Color(0xFF9E9E9E)};
    }
  }
}
