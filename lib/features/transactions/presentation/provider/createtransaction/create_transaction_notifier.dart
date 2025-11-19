// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/create_transaction.dart';
import 'package:go_router/go_router.dart';

class CreateTransactionState {
  final bool isLoading;
  final String? error;
  final bool success;

  final double? amount;
  final String? description;
  final String? note;
  final String? categoryId;
  final DateTime date;
  final TimeOfDay time;
  final String type; // "expense" | "income"

  const CreateTransactionState({
    this.isLoading = false,
    this.error,
    this.success = false,
    this.amount,
    this.description,
    this.note,
    this.categoryId,
    this.type = "expense",
    required this.date,
    required this.time,
  });

  CreateTransactionState copyWith({
    bool? isLoading,
    String? error,
    bool? success,
    double? amount,
    String? description,
    String? note,
    String? categoryId,
    String? type,
    DateTime? date,
    TimeOfDay? time,
  }) {
    return CreateTransactionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
      amount: amount ?? this.amount,
      description: description ?? this.description,
      note: note ?? this.note,
      categoryId: categoryId ?? this.categoryId,
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}

class CreateTransactionNotifier extends StateNotifier<CreateTransactionState> {
  final CreateTransaction _createTransaction;

  CreateTransactionNotifier(this._createTransaction)
      : super(
    CreateTransactionState(date: DateTime.now(), time: TimeOfDay.now()),
  );

  void setType(String value) {
    state = state.copyWith(type: value);
  }

  void setAmount(String value) {
    state = state.copyWith(amount: double.tryParse(value));
  }

  void setDescription(String value) {
    state = state.copyWith(description: value);
  }

  void setNote(String value) {
    state = state.copyWith(note: value);
  }

  void setCategory(String id) {
    state = state.copyWith(categoryId: id);
  }

  void setDate(DateTime value) {
    state = state.copyWith(date: value);
  }

  void setTime(TimeOfDay value) {
    state = state.copyWith(time: value);
  }

  Future<void> submit(BuildContext context) async {
    if (state.amount == null || state.amount == 0) {
      _showError(context, "Vui lòng nhập số tiền");
      return;
    }
    if (state.categoryId == null) {
      _showError(context, "Vui lòng chọn danh mục");
      return;
    }

    state = state.copyWith(isLoading: true);

    try {
      // convert date + time → timestamp
      final occurredAt =
          DateTime(
            state.date.year,
            state.date.month,
            state.date.day,
            state.time.hour,
            state.time.minute,
          ).millisecondsSinceEpoch ~/
              1000;

      await _createTransaction(
        amount: state.amount!,
        categoryId: state.categoryId!,
        type: state.type,
        description: state.description ?? "",
        note: state.note ?? "",
        occurredAt: occurredAt,
      );

      // QUAY VỀ TRANG TRANSACTIONS
      context.go(AppRoutes.transactions);
    } catch (e) {
      _showError(context, e.toString());
    }
  }

  void _showError(BuildContext context, String msg) {
    state = state.copyWith(error: msg);
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(msg), backgroundColor: Colors.red));
  }

  void onBack(BuildContext context) {
    context.go(AppRoutes.transactions);
  }
}
