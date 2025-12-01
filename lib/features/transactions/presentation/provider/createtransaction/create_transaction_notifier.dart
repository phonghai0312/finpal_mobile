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
    bool updateAmount = false,
    String? description,
    bool updateDescription = false,
    String? note,
    bool updateNote = false,
    String? categoryId,
    bool updateCategoryId = false,
    String? type,
    DateTime? date,
    TimeOfDay? time,
  }) {
    return CreateTransactionState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      success: success ?? this.success,
      amount: updateAmount ? amount : this.amount,
      description: updateDescription ? description : this.description,
      note: updateNote ? note : this.note,
      categoryId: updateCategoryId ? categoryId : this.categoryId,
      type: type ?? this.type,
      date: date ?? this.date,
      time: time ?? this.time,
    );
  }
}

class CreateTransactionNotifier extends StateNotifier<CreateTransactionState> {
  final CreateTransaction _createTransaction;
  final TextEditingController amountController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController noteController = TextEditingController();

  CreateTransactionNotifier(this._createTransaction)
      : super(
    CreateTransactionState(date: DateTime.now(), time: TimeOfDay.now()),
  ) {
    _initControllers();
  }

  void _initControllers() {
    amountController.text = state.amount?.toString() ?? '';
    descriptionController.text = state.description ?? '';
    noteController.text = state.note ?? '';

    amountController.addListener(() {
      setAmount(amountController.text);
    });
    descriptionController.addListener(() {
      setDescription(descriptionController.text);
    });
    noteController.addListener(() {
      setNote(noteController.text);
    });
  }

  @override
  void dispose() {
    amountController.dispose();
    descriptionController.dispose();
    noteController.dispose();
    super.dispose();
  }

  void setType(String value) {
    state = state.copyWith(type: value);
  }

  void setAmount(String value) {
    state = state.copyWith(
      amount: double.tryParse(value),
      updateAmount: true,
    );
  }

  void setDescription(String value) {
    state = state.copyWith(
      description: value,
      updateDescription: true,
    );
  }

  void setNote(String value) {
    state = state.copyWith(
      note: value,
      updateNote: true,
    );
  }

  void setCategory(String id) {
    state = state.copyWith(
      categoryId: id,
      updateCategoryId: true,
    );
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
