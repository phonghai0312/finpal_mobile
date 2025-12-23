import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fridge_to_fork_ai/features/transactions/data/datasources/transaction_remote_datasources.dart';
import 'package:fridge_to_fork_ai/features/transactions/presentation/provider/transaction/transaction_provider.dart';

class MonthFilterState {
  final int month;
  final int year;

  const MonthFilterState({required this.month, required this.year});

  factory MonthFilterState.current() {
    final now = DateTime.now();
    return MonthFilterState(month: now.month, year: now.year);
  }

  DateTime get start => DateTime(year, month, 1);

  DateTime get end =>
      DateTime(year, month + 1, 1).subtract(const Duration(minutes: 1));
}

class MonthFilterNotifier extends StateNotifier<MonthFilterState> {
  MonthFilterNotifier() : super(MonthFilterState.current());

  Future<void> bootstrap(TransactionRemoteDataSource remote) async {
    try {
      final list = await remote.getTransactions(pageSize: 100);
      if (list.isEmpty) return;
      list.sort((a, b) => b.occurredAt.compareTo(a.occurredAt));
      final latest = list.first;
      final date = DateTime.fromMillisecondsSinceEpoch(latest.occurredAt);
      state = MonthFilterState(month: date.month, year: date.year);
    } catch (_) {
      // keep default
    }
  }

  void setMonth(int month, {int? year}) {
    if (month < 1 || month > 12) return;
    final nextYear = year ?? state.year;
    if (month == state.month && nextYear == state.year) return;
    state = MonthFilterState(month: month, year: nextYear);
  }

  void setYear(int year) {
    if (year == state.year) return;
    state = MonthFilterState(month: state.month, year: year);
  }
}

final monthFilterProvider =
    StateNotifierProvider<MonthFilterNotifier, MonthFilterState>((ref) {
      final notifier = MonthFilterNotifier();
      final remote = ref.read(transactionRemoteDataSourceProvider);
      Future.microtask(() => notifier.bootstrap(remote));
      return notifier;
    });
