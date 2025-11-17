import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transaction_detail.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routing/app_routes.dart';

class TransactionDetailState {
  final bool isLoading;
  final Transaction? data;
  final String? error;

  const TransactionDetailState({this.isLoading = false, this.data, this.error});

  TransactionDetailState copyWith({
    bool? isLoading,
    Transaction? data,
    String? error,
  }) {
    return TransactionDetailState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
    );
  }
}

final selectedTransactionIdProvider = StateProvider<String?>((ref) => null);

class TransactionDetailNotifier extends StateNotifier<TransactionDetailState> {
  final GetTransactionDetail getTransactionDetail;
  final Ref ref;

  TransactionDetailNotifier(this.getTransactionDetail, this.ref)
    : super(const TransactionDetailState());
  Future<void> init() async {
    // tránh fetch lại nhiều lần khi state đã có data hoặc lỗi
    if (state.isLoading || state.data != null || state.error != null) {
      return;
    }
    await fetchDetail();
  }

  Future<void> fetchDetail() async {
    final id = ref.read(selectedTransactionIdProvider);

    if (id == null) {
      state = state.copyWith(error: "Transaction ID is missing");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      final tx = await getTransactionDetail(id);
      state = state.copyWith(isLoading: false, data: tx);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void onBack(BuildContext context) {
    context.go(AppRoutes.transactions);
  }
}
