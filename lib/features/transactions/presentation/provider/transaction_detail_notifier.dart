import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/models/transaction_creation_request_model.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/get_transaction_detail.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/config/routing/app_routes.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/delete_transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/update_transaction.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/usecase/create_transaction.dart';

enum TransactionType { expense, income }

class TransactionFormState {
  final double amount;
  final TransactionType type;
  final String? categoryId;
  final String? description;
  final String? userNote;
  final DateTime occurredAtDate;
  final TimeOfDay occurredAtTime;

  TransactionFormState({
    this.amount = 0.0,
    this.type = TransactionType.expense,
    this.categoryId,
    this.description,
    this.userNote,
    required this.occurredAtDate,
    required this.occurredAtTime,
  });

  TransactionFormState copyWith({
    double? amount,
    TransactionType? type,
    String? categoryId,
    String? description,
    String? userNote,
    DateTime? occurredAtDate,
    TimeOfDay? occurredAtTime,
  }) {
    return TransactionFormState(
      amount: amount ?? this.amount,
      type: type ?? this.type,
      categoryId: categoryId ?? this.categoryId,
      description: description ?? this.description,
      userNote: userNote ?? this.userNote,
      occurredAtDate: occurredAtDate ?? this.occurredAtDate,
      occurredAtTime: occurredAtTime ?? this.occurredAtTime,
    );
  }
}

class TransactionDetailState {
  final bool isLoading;
  final Transaction? data;
  final String? error;
  final TransactionFormState form;

  const TransactionDetailState({
    this.isLoading = false,
    this.data,
    this.error,
    required this.form,
  });

  TransactionDetailState copyWith({
    bool? isLoading,
    Transaction? data,
    String? error,
    TransactionFormState? form,
  }) {
    return TransactionDetailState(
      isLoading: isLoading ?? this.isLoading,
      data: data ?? this.data,
      error: error,
      form: form ?? this.form,
    );
  }
}

final selectedTransactionIdProvider = StateProvider<String?>((ref) => null);

class TransactionDetailNotifier extends StateNotifier<TransactionDetailState> {
  final GetTransactionDetail getTransactionDetail;
  final DeleteTransaction deleteTransaction;
  final UpdateTransactionUseCase updateTransaction;
  final CreateTransactionUseCase createTransactionUseCase;
  final Ref ref;

  TransactionDetailNotifier(
    this.getTransactionDetail,
    this.deleteTransaction,
    this.updateTransaction,
    this.createTransactionUseCase,
    this.ref,
  ) : super(TransactionDetailState(form: TransactionFormState(
          occurredAtDate: DateTime.now(),
          occurredAtTime: TimeOfDay.now(),
        )));

  Future<void> init() async {
    final id = ref.read(selectedTransactionIdProvider);
    if (id != null) {
      if (state.data != null && state.data!.id == id) {
        // Data for this ID is already loaded, no need to re-fetch
        return;
      }
      await fetchDetail(id);
    } else {
      // Reset form for new transaction
      state = state.copyWith(
        form: TransactionFormState(
          occurredAtDate: DateTime.now(),
          occurredAtTime: TimeOfDay.now(),
        ),
        data: null,
        error: null,
        isLoading: false,
      );
    }
  }

  Future<void> fetchDetail(String id) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final tx = await getTransactionDetail(id);
      state = state.copyWith(
        isLoading: false,
        data: tx,
        form: TransactionFormState(
          amount: tx.amount,
          type: tx.type == 'expense' ? TransactionType.expense : TransactionType.income,
          categoryId: tx.categoryId,
          description: tx.normalized.description,
          userNote: tx.userNote,
          occurredAtDate: DateTime.fromMillisecondsSinceEpoch(tx.occurredAt * 1000),
          occurredAtTime: TimeOfDay.fromDateTime(DateTime.fromMillisecondsSinceEpoch(tx.occurredAt * 1000)),
        ),
      );
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void updateAmount(String amount) {
    state = state.copyWith(form: state.form.copyWith(amount: double.tryParse(amount) ?? 0.0));
  }

  void updateType(TransactionType type) {
    state = state.copyWith(form: state.form.copyWith(type: type));
  }

  void updateCategory(String? categoryId) {
    state = state.copyWith(form: state.form.copyWith(categoryId: categoryId));
  }

  void updateDescription(String? description) {
    state = state.copyWith(form: state.form.copyWith(description: description));
  }

  void updateUserNote(String? userNote) {
    state = state.copyWith(form: state.form.copyWith(userNote: userNote));
  }

  void updateOccurredAtDate(DateTime date) {
    state = state.copyWith(form: state.form.copyWith(occurredAtDate: date));
  }

  void updateOccurredAtTime(TimeOfDay time) {
    state = state.copyWith(form: state.form.copyWith(occurredAtTime: time));
  }

  Future<void> saveTransaction(BuildContext context) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final form = state.form;
      final occurredDateTime = DateTime(
        form.occurredAtDate.year,
        form.occurredAtDate.month,
        form.occurredAtDate.day,
        form.occurredAtTime.hour,
        form.occurredAtTime.minute,
      );
      final occurredAtInSeconds = occurredDateTime.millisecondsSinceEpoch ~/ 1000;

      if (state.data == null) {
        // Create new transaction
        final request = TransactionCreationRequestModel(
          amount: form.amount,
          type: form.type == TransactionType.expense ? 'expense' : 'income',
          categoryId: form.categoryId,
          description: form.description,
          userNote: form.userNote,
          occurredAt: occurredAtInSeconds,
        );
        await createTransactionUseCase(transaction: request);
      } else {
        // Update existing transaction
        await updateTransaction(
          id: state.data!.id,
          categoryId: form.categoryId,
          userNote: form.userNote,
        );
      }
      state = state.copyWith(isLoading: false);
      context.go(AppRoutes.transactions);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: e.toString());
    }
  }

  void onBack(BuildContext context) {
    ref.read(selectedTransactionIdProvider.notifier).state = null;
    context.go(AppRoutes.transactions);
  }

  void onEdit(BuildContext context, Transaction transaction) {
    ref.read(selectedTransactionIdProvider.notifier).state = transaction.id;
    context.go(AppRoutes.editTransaction);
  }

  void onDelete(BuildContext context, Transaction transaction) async {
    final confirmed = await showCupertinoDialog<bool>(
      context: context,
      builder: (BuildContext dialogContext) {
        return CupertinoAlertDialog(
          title: const Text('Xác nhận xóa'),
          content: Text(
              'Bạn có chắc chắn muốn xóa giao dịch ${transaction.normalized.title ?? 'này'} không?'),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: const Text('Hủy'),
            ),
            CupertinoDialogAction(
              onPressed: () => Navigator.of(dialogContext).pop(true),
              isDestructiveAction: true,
              child: const Text('Xóa'),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      state = state.copyWith(isLoading: true, error: null);
      try {
        await deleteTransaction(transaction.id);
        state = state.copyWith(isLoading: false);
        context.go(AppRoutes.transactions);
      } catch (e) {
        state = state.copyWith(isLoading: false, error: e.toString());
      }
    }
  }
}
