library;

import 'package:fridge_to_fork_ai/features/stats/domain/repositories/stats_repositories.dart';
import 'package:fridge_to_fork_ai/features/transactions/domain/entities/transaction.dart';

class GetCategoryTransactions {
  final StatsRepository repository;

  GetCategoryTransactions(this.repository);

  Future<List<Transaction>> call({
    required int from,
    required int to,
    required String categoryKey,
  }) {
    return repository.getTransactionsByCategory(
      from: from,
      to: to,
      categoryKey: categoryKey,
    );
  }
}

/// catgoryID
